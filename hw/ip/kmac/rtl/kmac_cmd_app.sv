// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// KMAC command-based application interface

`include "prim_assert.sv"

module kmac_cmd_app
  import kmac_pkg::*;
  import sha3_pkg::keccak_strength_e;
  import sha3_pkg::sha3_mode_e;
#(
  parameter bit  EnMasking = 1'b1,
  localparam int Share     = EnMasking ? 2 : 1
) (
  input  clk_i,
  input  rst_ni,

  // External command interface
  input  capp_req_t req_i,
  output capp_rsp_t rsp_o,

  // TODO: implement status and error responses
  input [31:0] status_i,
  input [31:0] intr_state_i,
  input [31:0] err_code_i,
  
  // Command output to kmac_app
  output kmac_cmd_e cmd_o,
  input  logic      granted_i,

  // Configuration to kmac_app
  output logic             kmac_en_o,
  output sha3_mode_e       sha3_mode_o,
  output keccak_strength_e keccak_strength_o,
  output logic             msg_mask_o,

  // Data to kmac_app
  output logic                data_valid_o,
  output logic [MsgWidth-1:0] data_data_o[Share],
  output logic [MsgStrbW-1:0] data_strb_o,
  input  logic                data_ready_i,

  // From SHA3 core
  input  logic                  state_valid_i,
  input  [sha3_pkg::StateW-1:0] state_i[Share],
  input  keccak_strength_e      state_strength_i,
  input  sha3_mode_e            state_mode_i,

  input  prim_mubi_pkg::mubi4_t absorbed_i,
  input  logic                  block_processed_i,
  input  logic                  entropy_ready_pulse_i,

  input  logic                err_processed_i,
  input  lc_ctrl_pkg::lc_tx_t lc_escalate_en_i,

  output logic sparse_fsm_error_o,
  output logic counter_error_o
);

  // Encoding generated at commit 007b0cf36a using Python 3.10.19 with:
  // $ ./util/design/sparse-fsm-encode.py --language=sv \
  //     --seed 9618916198 --distance 3 --states 7 --bits 6
  //
  // Hamming distance histogram:
  //
  //  0: --
  //  1: --
  //  2: --
  //  3: |||||||||||||||||||| (57.14%)
  //  4: ||||||||||||||| (42.86%)
  //  5: --
  //  6: --
  //
  // Minimum Hamming distance: 3
  // Maximum Hamming distance: 4
  // Minimum Hamming weight: 1
  // Maximum Hamming weight: 5
  //
  localparam int StateWidth = 6;
  typedef enum logic [StateWidth-1:0] {
    StIdle           = 6'b011110,
    StWaitAfterGrant = 6'b000011,
    StAbsorbing      = 6'b110101,
    StProcessing     = 6'b111011,
    StPushingDigest  = 6'b101000,
    StDigestPushed   = 6'b000001, // TODO: regenerate states
    StSqueezing      = 6'b001101,
    StError          = 6'b010000,
    StResponding     = 6'b111111 // TODO: regenerate states
  } cmd_app_st_e;

  cmd_app_st_e state_d, state_q;

  `PRIM_FLOP_SPARSE_FSM(u_state_regs, state_d, state_q, cmd_app_st_e, StIdle)

  logic cmd_rsp_pending;
  logic cmd_rsp_sent;

  capp_rsp_meta_t cmd_rsp, cmd_rsp_d, cmd_rsp_q;
  cmd_app_st_e    state_after_cmd_rsp, state_after_cmd_rsp_d, state_after_cmd_rsp_q;

  /////////////////////
  // Request handler //
  /////////////////////
  capp_req_meta_t req_meta;
  logic           pending_request;
  logic           req_is_cmd;
  logic           req_is_data;
  kmac_cmd_e      pending_cmd;
  logic           ack_pending_cmd;
  logic           data_req_ready;
  
  assign req_meta        = req_i.data_s0[$bits(capp_req_meta_t)-1:0];
  assign pending_request = req_i.req_valid;
  assign req_is_cmd      = !req_i.req_is_data && pending_request;
  assign req_is_data     = req_i.req_is_data && pending_request;
  assign pending_cmd     = req_is_cmd ? req_meta.cmd : CmdNone;
  // TODO: Should we add an exclusivity check here? It is not required but can catch errors in the
  // assignments.
  // assign rsp_o.req_ready = req_is_cmd  ? ack_pending_req :
  //                          req_is_data ? ack_data_req    :
  //                                        1'b0;

  ///////////////////////////
  // Configuration checker //
  ///////////////////////////
  logic valid_sha3_strength;
  logic valid_shake_strength;
  logic valid_kmac_cfg;
  logic valid_mode_strength_raw;
  logic valid_mode_strength;
  logic valid_cfg;

  assign valid_sha3_strength = req_meta.cfg.kstrength inside {sha3_pkg::L224,
                                                              sha3_pkg::L256,
                                                              sha3_pkg::L384,
                                                              sha3_pkg::L512};

  assign valid_shake_strength = req_meta.cfg.kstrength inside {sha3_pkg::L128,
                                                               sha3_pkg::L256};

  assign valid_mode_strength_raw =
      req_meta.cfg.mode == sha3_pkg::Sha3                          ? valid_sha3_strength  :
      req_meta.cfg.mode inside {sha3_pkg::Shake, sha3_pkg::CShake} ? valid_shake_strength : 1'b0;

  assign valid_mode_strength = req_meta.cfg.en_unsupported_modestrength ? 1'b1 :
                                                                          valid_mode_strength_raw;

  // Entropy is signaled as ready once when SW writes a bit. We must latch this information
  logic cfg_entropy_ready;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni)              cfg_entropy_ready <= 1'b 0;
    else if (err_processed_i) cfg_entropy_ready <= 1'b 0;
    else if (entropy_ready_pulse_i && state_q == StIdle) begin
      cfg_entropy_ready <= 1'b 1;
    end
  end

  assign valid_kmac_cfg = cfg_entropy_ready && (req_meta.cfg.mode == sha3_pkg::CShake);

  assign valid_cfg = valid_mode_strength && (req_meta.cfg.kmac_en ? valid_kmac_cfg : 1'b1);

  assign kmac_en_o         = req_meta.cfg.kmac_en;
  assign sha3_mode_o       = req_meta.cfg.mode;
  assign keccak_strength_o = req_meta.cfg.kstrength;
  assign msg_mask_o        = req_meta.cfg.msg_mask;

  ///////////////////////
  // Data forward path //
  ///////////////////////
  assign data_data_o[0] = req_i.data_s0;
  if (EnMasking) begin : g_share1_data
    assign data_data_o[1] = req_i.data_s1;
  end
  assign data_strb_o = req_i.strb;

  always_comb begin
    data_valid_o   = 1'b0;
    data_req_ready = 1'b0;
    // Forward data requests while absorbing. We must include the state when we send an error
    // response due to an invalid command request during absorbing.
    if (state_q == StAbsorbing ||
        (state_q == StResponding && state_after_cmd_rsp_q == StAbsorbing)) begin
      data_valid_o = req_is_data ? req_i.req_valid : 1'b0;
      data_req_ready = req_is_data ? data_ready_i    : 1'b0;
    end
  end

  /////////////////
  // Data pusher //
  /////////////////
  logic data_rsp_pending;
  logic data_rsp_sent;
  logic pushing_last_digest;
  logic last_digest_pushed;
  logic discard_digest;
  logic [CappDigestWidth-1:0] data_rsp_s0, data_rsp_s1;
  logic [CappDigestWidth-1:0] selected_state[Share];

  // The maximal number of digest chunks is defined by the case with the largest rate.
  localparam int DigestCntW = $clog2((sha3_pkg::StateW - 2 * 128) / CappDigestWidth);
  logic [DigestCntW-1:0] digest_top;
  logic [DigestCntW-1:0] current_digest_idx;
  logic [DigestCntW-1:0] next_digest_idx;

  always_comb begin
    if (state_mode_i == sha3_pkg::Sha3) begin
      // Expose hash
      unique case (state_strength_i)
        sha3_pkg::L128: digest_top = DigestCntW'(128 / CappDigestWidth);
        sha3_pkg::L224: digest_top = DigestCntW'(224 / CappDigestWidth);
        sha3_pkg::L256: digest_top = DigestCntW'(256 / CappDigestWidth);
        sha3_pkg::L384: digest_top = DigestCntW'(384 / CappDigestWidth);
        sha3_pkg::L512: digest_top = DigestCntW'(512 / CappDigestWidth);
        // Expose the least amount of hash if strength would be invalid
        default:        digest_top = DigestCntW'(128 / CappDigestWidth);
      endcase
    end else begin
      // Expose rate for SHAKE and cSHAKE
      // TODO: use KeccakBitCapacity to compute the number of chunks?
      unique case (state_strength_i)
        sha3_pkg::L128: digest_top = DigestCntW'((sha3_pkg::StateW - 2 * 128) / CappDigestWidth);
        sha3_pkg::L224: digest_top = DigestCntW'((sha3_pkg::StateW - 2 * 224) / CappDigestWidth);
        sha3_pkg::L256: digest_top = DigestCntW'((sha3_pkg::StateW - 2 * 256) / CappDigestWidth);
        sha3_pkg::L384: digest_top = DigestCntW'((sha3_pkg::StateW - 2 * 384) / CappDigestWidth);
        sha3_pkg::L512: digest_top = DigestCntW'((sha3_pkg::StateW - 2 * 512) / CappDigestWidth);
        // Expose the least amount of state if strength would be invalid
        default:        digest_top = DigestCntW'((sha3_pkg::StateW - 2 * 512) / CappDigestWidth);
      endcase
    end
  end

  // SEC_CM CTR.REDUN
  prim_count #(
    .Width(DigestCntW)
  ) u_digest_word_count (
    .clk_i,
    .rst_ni,
    .clr_i             (state_q == StIdle || last_digest_pushed || discard_digest),
    .set_i             (1'b0),
    .set_cnt_i         ('0),
    .incr_en_i         (1'b1),
    .decr_en_i         (1'b0),
    .step_i            (DigestCntW'(1)),
    .commit_i          (data_rsp_sent),
    .cnt_o             (current_digest_idx),
    .cnt_after_commit_o(next_digest_idx),
    .err_o             (counter_error_o)
  );

  for (genvar i = 0; i < Share; i++) begin
    assign selected_state[i] = state_i[i][current_digest_idx * CappDigestWidth +: CappDigestWidth];
  end
  assign data_rsp_pending    = state_valid_i && state_q == StPushingDigest;
  assign pushing_last_digest = next_digest_idx == digest_top;
  assign last_digest_pushed  = data_rsp_sent && pushing_last_digest;
  
  // Only expose the state if we want to send a response.
  assign data_rsp_s0 = data_rsp_pending ? selected_state[0] : '0;
  if (EnMasking) begin : g_data_masked
    assign data_rsp_s1 = data_rsp_pending ? selected_state[1] : '0;
  end else begin
    assign data_rsp_s1 = '0;
  end

  //////////////////////
  // Response handler //
  //////////////////////
  // Arbitrate between command responses and data responses.
  // NOTE: The arbitration is not valid-locked in!
  // This is required if there happens an error. The data
  // can get violated before the handshake happens (actually this already violates the locked-in
  // condition as the data can change) and thus any error response must have priority.
  logic response_sent;
  assign response_sent = rsp_o.rsp_valid & req_i.rsp_ready;

  // TODO: suppress any response if error is present. only send error response.

  always_comb begin
    rsp_o = '0; // TODO: the ready is now in the request. Should we move it ito rsp_o to have the two channels independent?
    cmd_rsp_sent = 1'b0;
    data_rsp_sent = 1'b0;

    rsp_o.req_ready = ack_pending_cmd || data_req_ready;

    if (cmd_rsp_pending) begin
      rsp_o.rsp_valid = 1'b1;
      rsp_o.digest_s0 = CappDigestWidth'(cmd_rsp);
      rsp_o.digest_s1 = '0;
      cmd_rsp_sent    = response_sent;
    end else if (data_rsp_pending) begin
      // Maybe we can optimize the arbiter by ensuring that the data response generator does not
      // generate a response if FSM is in the StResponding state. Then we can simply OR both
      // responses instead of arbitrating. Hm no, this would require a blanker for the response
      // data / code so we can mix data properly. So it is probably better to have a regular mux.
      // But if we enforce by design that only one response can be active at the same time, we can
      // use a `unique case (1'b1)` structure which is maybe slightly more efficient.
      // As it is now, we have a clear priority and the FSM is independent of the pusher. So both
      // can just place responses and here we decide which response is sent.
      rsp_o.rsp_valid = 1'b1;
      rsp_o.digest_s0 = data_rsp_s0;
      rsp_o.digest_s1 = data_rsp_s1;
      data_rsp_sent   = response_sent;
    end
  end

  ////////////////
  // CmdApp FSM //
  ////////////////
  always_comb begin
    state_d = state_q;

    // Reset pending response data per default.
    cmd_rsp             = CAPP_RESPONSE_INVALID;
    state_after_cmd_rsp = StError;

    cmd_o = CmdNone;

    cmd_rsp_pending = 1'b0;
    ack_pending_cmd = 1'b0;

    sparse_fsm_error_o = 1'b0;

    unique case (state_q)
      StIdle: begin
        // If there is a pending start command:
        //   - If configuration is valid, place claim request.
        //     - If granted:
        //       - Send response and ack command.
        //     - Else: Wait for next cycle. It is save to withdraw the command in the next cycle
        //             as kmac_app grants immediately.
        //   - If configuration is invalid, send error response and ack command.
        if (pending_cmd == CmdStart) begin
          if (valid_cfg) begin
            // This forwards the configuration to kmac_app. If the kmac_app selects the CmdApp,
            // the current configuration is latched there. As the configuration signals must be
            // stable until we have a grant, we cannot yet handshake the START command.
            state_d = StIdle;
            cmd_o   = CmdStart;
            if (granted_i) begin
              // Send response that KMAC is now claimed. Transfer to Absorbing state once response has
              // been sent.
              cmd_rsp = '{
                response: CappAck,
                info:     '0
              };
              cmd_rsp_pending = 1'b1;
              state_d         = StWaitAfterGrant;
              // We can now handshake the START command.
              ack_pending_cmd = 1'b1;
            end
          end else begin
            // Send error response that START was unsuccessful due to bad configuration.
            // Return to idle once response has been sent.
            cmd_rsp = '{
              response: CappErr,
              info:     '0 // TODO: Maybe add details: entropy not ready or bad config.
            };
            cmd_rsp_pending = 1'b1;
            ack_pending_cmd = 1'b1;
          end
        end else if (pending_request) begin
          // Handle any other command or data request. It must be acked and an error response must
          // be sent.
          cmd_rsp = '{
            response: CappErr,
            info:     '0 // TODO: Add error info. Either cmd error or unexpected data request.
          };
          cmd_rsp_pending = 1'b1;
          ack_pending_cmd = 1'b1;
        end
      end
      StWaitAfterGrant: begin
        // We must wait for one cycle after receiving the grant until the kmac_app has latched and
        // sent the START command to the downstream core. In this cycle we may not send a command
        // and thus we simply stall any incoming request.
        // The data path is anyway not ready because the SHA3 core also requires 1 cycle delay
        // after the start command arrived. In theory we could skip this state if the response
        // cannot be sent immediately. But for simplicity we do not skip it conditionally.
        state_d = StAbsorbing;
        cmd_o   = CmdNone;
      end
      StAbsorbing: begin
        // Reject any commands except PROCESS.
        // All data requests are forwarded and must not be handled by this FSM.
        if (pending_cmd == CmdProcess) begin
          // Start processing. The command must only be pulsed once, so immediately ack this command.
          cmd_o = CmdProcess;
          cmd_rsp = '{
            response: CappAck,
            info:     '0
          };
          cmd_rsp_pending = 1'b1;
          state_d         = StProcessing;
          ack_pending_cmd = 1'b1;
        end else if (pending_cmd != CmdNone) begin
          // Send error response
          cmd_rsp = '{
            response: CappErr,
            info:     '0 // TODO: Add error info. Invalid CMD sequence.
          };
          cmd_rsp_pending = 1'b1;
          ack_pending_cmd = 1'b1;
        end
      end
      StProcessing: begin
        // Wait until core has processed data, then start pushing digest. Any request in this phase
        // is ignored / stalled. This ensures we never switch to the Responding state.
        // There is no response once absorbed, the application waits for the first digest response.
        if (absorbed_i) begin
          state_d = StPushingDigest;
        end
      end
      StPushingDigest,
      StDigestPushed: begin
        if (last_digest_pushed) begin
          state_d = StDigestPushed;
        end

        // Any request except a DONE or RUN command are invalid.
        if (pending_cmd == CmdDone) begin
          cmd_o   = CmdDone;
          state_d = StIdle;
          cmd_rsp = '{
            response: CappAck,
            info:     '0 // TODO: Add info. probably command?
          };
          cmd_rsp_pending = 1'b1;
          ack_pending_cmd = 1'b1;
          // Reset the digest pusher
          discard_digest  = 1'b1;
        end else if (pending_cmd == CmdManualRun) begin
          cmd_o   = CmdManualRun;
          state_d = StSqueezing;
          cmd_rsp = '{
            response: CappAck,
            info:     '0 // TODO: Add info.
          };
          cmd_rsp_pending = 1'b1;
          ack_pending_cmd = 1'b1;
          // Reset the digest pusher
          discard_digest  = 1'b1;
        end else if (pending_request) begin
          // Send error response
          cmd_rsp = '{
            response: CappErr,
            info:     '0 // TODO: Add error info. Invalid CMD sequence or data request.
          };
          cmd_rsp_pending = 1'b1;
          ack_pending_cmd = 1'b1;
        end
      end
      StSqueezing: begin
        // Wait until core has performed a squeeze, then start pushing digest. Any request in this
        // phase is ignored / stalled. This ensures we never switch to the Responding state.
        // There is no response once squeezed, the application waits for the first digest response.
        if (block_processed_i) begin
          state_d = StPushingDigest;
        end
      end
      StResponding: begin
        // Keep the currently pending response information and try to send it again.
        cmd_rsp_pending = 1'b1;
        cmd_rsp         = cmd_rsp_q;
        state_d         = state_after_cmd_rsp_q;
      end
      StError: begin
        sparse_fsm_error_o = 1'b1;
      end
      default: begin
        state_d            = StError;
        sparse_fsm_error_o = 1'b1;
      end
    endcase

    // If we wanted to send a response but we could not in this cycle, go to or stay in the
    // Responding state and save where we wanted to go.
    if (cmd_rsp_pending && !cmd_rsp_sent) begin
      state_after_cmd_rsp = state_d;
      state_d             = StResponding;
    end

    // In case of an error?
  end

  // Register current response or clear it once sent.
  assign state_after_cmd_rsp_d = cmd_rsp_sent ? StError               : state_after_cmd_rsp;
  assign cmd_rsp_d             = cmd_rsp_sent ? CAPP_RESPONSE_INVALID : cmd_rsp;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      cmd_rsp_q             <= CAPP_RESPONSE_INVALID; // Set to invalid response code?
      state_after_cmd_rsp_q <= StError;
    end else begin
      cmd_rsp_q             <= cmd_rsp_d;
      state_after_cmd_rsp_q <= state_after_cmd_rsp_d;
    end
  end

endmodule
