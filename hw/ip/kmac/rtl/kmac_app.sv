// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// KMAC Application interface
//
// This module implements the app interface which arbitrates between the SW interface and up to
// NumAppIntf hardware app interfaces. While a session is active (either an app or SW), other
// requests are stalled.
//
// There are two kind of app interfaces: Static interfaces which have a configuration defined at
// compile-time and only a one-shot digest can be retrieved. In contrast, a dynamic interface can
// send the desired hashing configuration at run time and supports XOF operation.

`include "prim_assert.sv"

module kmac_app
  import kmac_pkg::*;
#(
  // App specific configs are defined in kmac_pkg
  parameter  bit          EnMasking          = 1'b0,
  localparam int          Share              = (EnMasking) ? 2 : 1, // derived parameter
  parameter  bit          SecIdleAcceptSwMsg = 1'b0,
  parameter  int unsigned NumAppIntf         = 4,
  parameter  app_config_t AppCfg[NumAppIntf] = '{AppCfgKeyMgr, AppCfgLcCtrl,
                                                 AppCfgRomCtrl, AppCfgOtbn}
) (
  input clk_i,
  input rst_ni,

  // Secret Key from register
  input [MaxKeyLen-1:0] reg_key_data_i[Share],
  input key_len_e       reg_key_len_i,

  // Prefix from register
  input [sha3_pkg::NSRegisterSize*8-1:0] reg_prefix_i,

  // mode, strength, kmac_en from register
  input logic                       reg_kmac_en_i,
  input sha3_pkg::sha3_mode_e       reg_sha3_mode_i,
  input sha3_pkg::keccak_strength_e reg_keccak_strength_i,

  // Data from Software
  input                sw_valid_i,
  input [MsgWidth-1:0] sw_data_i,
  input [MsgWidth-1:0] sw_strb_i,
  output logic         sw_ready_o,

  // KeyMgr Sideload Key interface
  input keymgr_pkg::hw_key_req_t keymgr_key_i,

  // Application Message in/ Digest out interface + control signals
  input  app_req_t [NumAppIntf-1:0] app_i,
  output app_rsp_t [NumAppIntf-1:0] app_o,

  // to KMAC Core: Secret key
  output logic [MaxKeyLen-1:0] key_data_o[Share],
  output key_len_e             key_len_o,
  output logic                 key_valid_o,

  // to MSG_FIFO
  output logic                kmac_valid_o,
  output logic [MsgWidth-1:0] kmac_data_o[Share],
  // This strobe is on bit level for the packer. The FIFO will then convert it again to byte level.
  output logic [MsgWidth-1:0] kmac_strb_o,
  input  logic                kmac_ready_i,
  output logic                kmac_bypass_fifo_o,

  // KMAC Core
  output logic kmac_en_o,

  // To Sha3 Core
  output logic [sha3_pkg::NSRegisterSize*8-1:0] sha3_prefix_o,
  output sha3_pkg::sha3_mode_e                  sha3_mode_o,
  output sha3_pkg::keccak_strength_e            keccak_strength_o,

  // STATE from SHA3 Core
  input                        keccak_state_valid_i,
  input [sha3_pkg::StateW-1:0] keccak_state_i[Share],

  // to STATE TL-window if Application is not active, the incoming state goes to
  // register if kdf_en is set, the state value goes to application and the
  // output to the register is all zero.
  output logic                        reg_state_valid_o,
  output logic [sha3_pkg::StateW-1:0] reg_state_o[Share],

  // Controls for SW and CmdApp operations whether to take the key from the key manager sideload
  // interface or registers. For KMAC operations initiated by an app interface, we always take the
  // sideloaded key.
  // If set, the key for KMAC is taken from the KeyMgr sideload interface.
  // If reset, the key is taken from the registers.
  input logic keymgr_key_en_i,

  // Commands
  // Command from software
  input kmac_cmd_e sw_cmd_i,

  // from SHA3
  input prim_mubi_pkg::mubi4_t absorbed_i,
  input logic                  squeezing_i,

  // to KMAC
  output kmac_cmd_e cmd_o,

  // to SW
  output prim_mubi_pkg::mubi4_t absorbed_o,

  // To status
  output logic app_active_o,

  // Status
  // - entropy_ready_i: Entropy configured by SW. It is used to check if App
  //                    is OK to request.
  input prim_mubi_pkg::mubi4_t entropy_ready_i,

  // Error input
  // This error comes from KMAC/SHA3 engine and is pulsed if a wrong command sequence is detected.
  // The app interface delivers the error signal to the app to drop the current operation and can
  // re-initiate the operation.
  // If error happens, regardless of SW-initiated or app-initiated, the error
  // is reported to the ERR_CODE so that SW can look into.
  input error_i,

  // SW sets err_processed bit in CTRL then the logic goes to Idle
  input err_processed_i,

  output prim_mubi_pkg::mubi4_t clear_after_error_o,

  // error_o value is pushed to Error FIFO at KMAC/SHA3 top and reported to SW
  output kmac_pkg::err_t error_o,

  // Life cycle
  input  lc_ctrl_pkg::lc_tx_t lc_escalate_en_i,

  output logic sparse_fsm_error_o,
  output logic counter_error_o
);

  import sha3_pkg::KeccakBitCapacity;
  import sha3_pkg::L128;
  import sha3_pkg::L224;
  import sha3_pkg::L256;
  import sha3_pkg::L384;
  import sha3_pkg::L512;

  /////////////////
  // Definitions //
  /////////////////

  // Digest width is same to the key width `keymgr_pkg::KeyWidth`.
  localparam int KeyMgrKeyW = $bits(keymgr_key_i.key[0]);

  localparam key_len_e KeyLengths [5] = '{Key128, Key192, Key256, Key384, Key512};

  localparam int SelKeySize = (AppKeyW == 128) ? 0 :
                              (AppKeyW == 192) ? 1 :
                              (AppKeyW == 256) ? 2 :
                              (AppKeyW == 384) ? 3 :
                              (AppKeyW == 512) ? 4 : 0 ;
  localparam int SelDigSize = (AppDigestW == 128) ? 0 :
                              (AppDigestW == 192) ? 1 :
                              (AppDigestW == 256) ? 2 :
                              (AppDigestW == 384) ? 3 :
                              (AppDigestW == 512) ? 4 : 0 ;
  localparam key_len_e SideloadedKey = KeyLengths[SelKeySize];

  // Define right_encode(outlen) value here
  // Look at kmac_pkg::key_len_e for the kinds of key size
  //
  // These values should be exactly the same as the key length encodings
  // in kmac_core.sv, with the only difference being that the byte representing
  // the byte-length of the encoded value is in the MSB position due to right encoding
  // instead of in the LSB position (left encoding).
  localparam int OutLenW = 24;
  localparam logic [OutLenW-1:0] EncodedOutLen [5]= '{
    24'h 0001_80, // Key128
    24'h 0001_C0, // Key192
    24'h 02_0001, // Key256
    24'h 02_8001, // Key384
    24'h 02_0002  // Key512
  };

  localparam logic [OutLenW-1:0] EncodedOutLenStrb [5] = '{
    24'h 00FFFF, // Key128,
    24'h 00FFFF, // Key192
    24'h FFFFFF, // Key256
    24'h FFFFFF, // Key384
    24'h FFFFFF  // Key512
  };

  /////////////
  // Signals //
  /////////////

  st_e st, st_d;

  logic keymgr_key_used;

  // app_rsp_t signals
  // The state machine controls mux selection, which controls the ready signal
  // the other responses are controlled in separate logic. So define the signals
  // here and merge them to the response.
  app_rsp_t app_rsp;
  logic app_data_ready, fsm_data_ready;
  logic app_digest_valid, fsm_digest_done_q, fsm_digest_done_d;
  logic app_finish_rsp_valid, app_error_rsp_valid;
  logic app_finish_rsp_is_error;
  logic app_req_ready;
  logic app_process_cmd_received;
  logic [AppDigestW-1:0] app_digest[2];

  // One more slot for value NumAppIntf. It is the value when no app intf is
  // chosen.
  localparam int unsigned AppIdxW = $clog2(NumAppIntf);

  // app_id indicates, which app interface was chosen. various logic use this
  // value to get the config or return the data.
  logic [AppIdxW-1:0] app_id, app_id_d;
  logic               clr_appid, set_appid;

  // Output length
  logic [OutLenW-1:0] encoded_outlen, encoded_outlen_strb;

  // state output
  // Mux selection signal
  app_mux_sel_e mux_sel;
  app_mux_sel_e mux_sel_buf_output;
  app_mux_sel_e mux_sel_buf_err_check;
  app_mux_sel_e mux_sel_buf_kmac;

  // Error checking logic

  kmac_pkg::err_t fsm_err, mux_err;

  logic service_rejected_error;
  logic service_rejected_error_set, service_rejected_error_clr;
  logic err_during_sw_d, err_during_sw_q;
  logic err_sha3_during_app, err_sha3_during_app_d, err_sha3_during_app_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni)                         service_rejected_error <= 1'b 0;
    else if (service_rejected_error_set) service_rejected_error <= 1'b 1;
    else if (service_rejected_error_clr) service_rejected_error <= 1'b 0;
  end

  ////////////////////////////
  // Application Mux/ Demux //
  ////////////////////////////

  assign app_rsp = '{
    req_ready: app_data_ready | fsm_data_ready | app_req_ready,
    rsp_valid: app_digest_valid | fsm_digest_done_q | app_finish_rsp_valid | app_error_rsp_valid,
    digest_s0: app_digest[0],
    digest_s1: app_digest[1],
    // If fsm asserts done, we are handling an error case.
    error:     fsm_digest_done_q | sparse_fsm_error_o | service_rejected_error |
               app_error_rsp_valid | app_finish_rsp_is_error,
    finished:  app_finish_rsp_valid
  };

  // app_digest_valid, app_finish_rsp_valid, app_error_rsp_valid and may never be true at the same
  // time because it would mean that one response tries to overrule a pending response.
  `ASSERT(AppOnlyOneRspSourceActive_A, 
      $onehot0({app_digest_valid, app_finish_rsp_valid, app_error_rsp_valid}))

  // Processing return data.
  // sends to only selected app intf.
  // clear digest right after done to not leak info to other interface
  always_comb begin
    for (int unsigned i = 0 ; i < NumAppIntf ; i++) begin
      if (i == app_id) begin
        app_o[i] = app_rsp;
      end else begin
        app_o[i] = '{ // TODO: use default parameter?
          req_ready: 1'b 0,
          rsp_valid: 1'b 0,
          digest_s0: '0,
          digest_s1: '0,
          error:     1'b0,
          finished:  1'b0
        };
      end
    end
  end

  /////////////////////////////
  // Application arbitration //
  /////////////////////////////
  // app_id latch
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) app_id <= AppIdxW'(0) ; // Do not select any
    else if (clr_appid) app_id <= AppIdxW'(0);
    else if (set_appid) app_id <= app_id_d;
  end

  // app_id selection as of now, app_id uses Priority. The assumption is that
  //  the request normally does not collide. (ROM_CTRL activates very early
  //  stage at the boot sequence)
  //
  //  If this assumption is not true, consider RR arbiter.

  // Prep for arbiter
  logic [NumAppIntf-1:0] app_req_valids;
  logic [NumAppIntf-1:0] unused_app_gnts;
  logic [$clog2(NumAppIntf)-1:0] arb_idx;
  logic arb_valid;
  logic arb_ready;

  always_comb begin
    app_req_valids = '0;
    for (int unsigned i = 0 ; i < NumAppIntf ; i++) begin
      app_req_valids[i] = app_i[i].req_valid;
    end
  end

  // pipelining issue
  // when request is pipelined, then when valid is deasserted, it can still result in a grant!
  // the same issues is also present for the CmdApp..
  // We can fully cut the request path. it is actually regularly valid/ready handshaked.
  prim_arbiter_fixed #(
    .N (NumAppIntf),
    .DW(1),
    .EnDataPort(1'b 0)
  ) u_appid_arb (
    .clk_i,
    .rst_ni,

    .req_i  (app_req_valids),
    .data_i ('{default:'0}),
    .gnt_o  (unused_app_gnts),
    .idx_o  (arb_idx),

    .valid_o (arb_valid),
    .data_o  (), // not used
    .ready_i (arb_ready)
  );

  assign app_id_d = AppIdxW'(arb_idx);
  assign arb_ready = set_appid;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) fsm_digest_done_q <= 1'b 0;
    else         fsm_digest_done_q <= fsm_digest_done_d;
  end

  /////////////////////////////////////////////////////
  // Application configuration selection and checker //
  /////////////////////////////////////////////////////
  app_req_t app_req;
  assign app_req = app_i[app_id];

  app_config_t app_cfg_q;
  app_config_t app_cfg_d;

  // Select the new configuration from either the compile time defined configuration or from the
  // supplied dynamic configuration. This operates on the non-latched request.
  always_comb begin
    app_cfg_d = AppCfg[arb_idx];
    // Overrule configuration with send configuration if it is dynamic.
    if (app_cfg_d.Type == AppDynamic) begin
      // TODO: define locations of bits
      app_cfg_d.KeccakStrength = sha3_pkg::keccak_strength_e'(app_i[arb_idx].data_s0[2:0]);
      app_cfg_d.Mode           = app_mode_e'(app_i[arb_idx].data_s0[11:10]);
      // For KMAC always use prefix defined at compile time. This saves the prefix check.
      // Otherwise use prefix from CSR.
      app_cfg_d.PrefixMode = app_cfg_d.Mode == AppKMAC ? 1'b1 : 1'b0;
      app_cfg_d.EnXof      = app_i[arb_idx].data_s0[20];
    end
  end

  logic valid_app_sha3_strength;
  logic valid_app_shake_strength;
  logic valid_app_kmac_cfg;
  logic valid_app_mode_strength_raw;
  logic valid_app_mode_strength;
  logic valid_app_cfg;

  assign valid_app_sha3_strength = app_cfg_q.KeccakStrength inside {sha3_pkg::L224,
                                                                    sha3_pkg::L256,
                                                                    sha3_pkg::L384,
                                                                    sha3_pkg::L512};

  assign valid_app_shake_strength = app_cfg_q.KeccakStrength inside {sha3_pkg::L128,
                                                                     sha3_pkg::L256};

  assign valid_app_mode_strength_raw =
      app_cfg_q.Mode == AppSHA3                            ? valid_app_sha3_strength  :
      app_cfg_q.Mode inside {AppShake, AppCShake, AppKMAC} ? valid_app_shake_strength : 1'b0;

  // Ignore the mode and strength check if app allows unsupported combinations.
  assign valid_app_mode_strength = valid_app_mode_strength_raw ||
                                   app_cfg_q.EnUnsupportedModeStrength;

  // The entropy is needed for KMAC operation.
  // TODO: original check was on strict false. Is strict true really the opposite?
  assign valid_app_kmac_cfg = prim_mubi_pkg::mubi4_test_true_strict(entropy_ready_i);

  assign valid_app_cfg = valid_app_mode_strength &&
                         (app_cfg_q.Mode == AppKMAC ? valid_app_kmac_cfg : 1'b1);

  // The compile-time defined configuration must always result in a valid mode-strength
  // configuration.
  `ASSERT(ConfigValidIfStatic_A, app_cfg_q.Type == AppStatic |-> valid_app_mode_strength)

  /////////
  // FSM //
  /////////

  // State register
  `PRIM_FLOP_SPARSE_FSM(u_state_regs, st_d, st, st_e, StIdle)

  // Create a lint error to reduce the risk of accidentally enabling this feature.
  `ASSERT_STATIC_LINT_ERROR(KmacSecIdleAcceptSwMsgNonDefault, SecIdleAcceptSwMsg == 0)

  logic digest_parts_available;
  logic squeeze_again;
  logic app_push_digest;
  logic reset_digest_pusher;
  logic key_used_but_invalid;
  logic pending_digest_rsp_d, pending_digest_rsp_q;
  logic pending_error_rsp_d, pending_error_rsp_q;
  logic message_parts_received_d, message_parts_received_q;
  logic err_processed_d, err_processed_q;
  logic message_part_handshaked;

  assign message_part_handshaked = st == StAppMsg && app_req.req_valid && app_rsp.req_ready;

  assign message_parts_received_d =
      message_part_handshaked ? 1'b1 :                    // set
      (st == StIdle)          ? 1'b0 :                    // reset
                                message_parts_received_q; // hold

  // Only set flag if this bit is relevant for the app interface, i.e., a hashing operation is
  // ongoing (this includes SW- and app-triggered operations).
  assign err_processed_d = err_processed_i && (st != StIdle) ? 1'b1 :           // set
                           st == StIdle                      ? 1'b0 :           // reset
                                                               err_processed_q; // hold

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      message_parts_received_q <= 1'b0;
      err_processed_q          <= 1'b0;
      pending_digest_rsp_q     <= 1'b0;
      pending_error_rsp_q      <= 1'b0;
    end else begin
      message_parts_received_q <= message_parts_received_d;
      err_processed_q          <= err_processed_d;
      pending_digest_rsp_q     <= pending_digest_rsp_d;
      pending_error_rsp_q      <= pending_error_rsp_d;
    end
  end

  // Next State & output logic
  // SEC_CM: FSM.SPARSE
  always_comb begin
    st_d = st;

    mux_sel = SecIdleAcceptSwMsg ? SelSw : SelNone;

    // app_id control
    set_appid = 1'b 0;
    clr_appid = 1'b 0;

    // Commands
    cmd_o = CmdNone;

    // Software output
    absorbed_o = prim_mubi_pkg::MuBi4False;

    // Error
    fsm_err = '{valid: 1'b 0, code: ErrNone, info: '0};
    sparse_fsm_error_o = 1'b 0;

    clear_after_error_o = prim_mubi_pkg::MuBi4False;

    service_rejected_error_set = 1'b 0;
    service_rejected_error_clr = 1'b 0;

    // If an error happens, FSM asserts data ready but discard incoming message parts.
    fsm_data_ready = 1'b 0;
    fsm_digest_done_d = 1'b 0;

    // Bypass FIFO if masked app is active
    kmac_bypass_fifo_o = 1'b0;

    // Ready signal to handshake requests for dynamic interfaces
    app_req_ready  = 1'b0;

    // If the last request has an empty strobe, do not forward data but just send the process
    // command (or advance to the output length append state for KMAC).
    app_process_cmd_received = 1'b0;

    // Whether to push a digest part or reset the pusher.
    app_push_digest     = 1'b0;
    reset_digest_pusher = 1'b0;
    app_error_rsp_valid = 1'b0;

    // Finish response
    app_finish_rsp_valid    = 1'b0;
    app_finish_rsp_is_error = 1'b0;

    unique case (st)
      StIdle: begin
        st_d = StIdle;

        if (arb_valid) begin
          st_d = StAppCfg;
          // choose app_id
          set_appid = 1'b 1;
        end else if (sw_cmd_i == CmdStart) begin
          st_d = StSw;
          // Software initiates the sequence
          cmd_o = CmdStart;
        end
      end

      StAppCfg: begin
        if (!valid_app_cfg) begin
          // Either the entropy source was not ready for a KMAC operation, or the App configuration
          // is invalid or the configuration in the registers supplied by SW is invalid.
          // In this error case we still go to the "message absorb" phase but no data is forwarded
          // to the actual SHA3 core. This simplifies the error handling on the application side.
          st_d                       = StErrorAwaitMsg;
          service_rejected_error_set = 1'b 1;
        end else begin
          // The configuration is valid and also latched. We can now send the start command and
          // begin to absorb the message.
          st_d  = StAppMsg;
          cmd_o = CmdStart;
        end
        // Handshake the configuration request also if there is an error (incl. key invalid error).
        // This is required as an application interface still must send the full data (at least
        // one beat with the last flag set) so that the app interface can bring back the KMAC into
        // the Idle state.
        app_req_ready = app_cfg_q.Type == AppDynamic;
      end

      StAppMsg: begin
        st_d               = StAppMsg;
        mux_sel            = SelApp;
        kmac_bypass_fifo_o = app_cfg_q.Masked;

        // The app can end the message phase without sending any data if it sets the strobe to
        // '0. In this case the data valid is not forwarded to the FIFO and the request is
        // immediately handshaked. This command is only valid once the app already has sent some
        // message parts as otherwise the same request represents an empty message. Note that we
        // can immediately send the process command as it is latched downstream in case the hashing
        // engine is still absorbing previous message parts.
        app_process_cmd_received = app_cfg_q.Type == AppDynamic &&
                                   message_parts_received_q     &&
                                   app_req.strb == '0           &&
                                   app_req.last                 &&
                                   app_req.req_valid;
        app_req_ready            = app_process_cmd_received;

        if (app_process_cmd_received ||
            (app_req.req_valid && app_rsp.req_ready && app_req.last)) begin
          if (app_cfg_q.Mode == AppKMAC) begin
            st_d = StAppOutLen;
          end else begin
            st_d = StAppProcess;
          end
        end else if (key_used_but_invalid) begin
          // Error out if the key is used but it is invalid. This error can be ignored if in the
          // same cycle the last message was handshaked. The reason is that for KMAC the key is
          // used before any message parts are absorbed. So if the last message part is handshaked,
          // the key is already fully absorbed.
          st_d = StErrorKeyNotValid;
        end else if (err_sha3_during_app) begin
          st_d = StErrorAwaitMsg;
        end
      end

      StAppOutLen: begin
        mux_sel            = SelOutLen;
        kmac_bypass_fifo_o = app_cfg_q.Masked;

        if (kmac_valid_o && kmac_ready_i) begin
          st_d = StAppProcess;
        end else begin
          st_d = StAppOutLen;
        end
      end

      StAppProcess: begin
        cmd_o              = CmdProcess;
        st_d               = StAppWait;
        // Bypass must be stable until process command has been sent.
        kmac_bypass_fifo_o = app_cfg_q.Masked;
      end

      StAppWait: begin
        st_d = StAppWait;

        // absorbed_i and squeezing_i are pulsed once the processing / squeezing has finished.
        if (prim_mubi_pkg::mubi4_test_true_strict(absorbed_i) ||
            (squeezing_i && app_cfg_q.Type == AppDynamic)) begin
          st_d                = StAppPushDigest;
          reset_digest_pusher = 1'b1;
        end
      end

      StAppPushDigest: begin
        // Static interface:
        // - Return full digest in one handshaked response and return to idle (via finish).
        // Dynamic interface:
        // - Push the available digest / rate in parts.
        // - For SHAKE and CSHAKE, if digest / rate is fully pushed, trigger a squeeze.
        // - End the session if a finish request arrives.
        st_d            = StAppPushDigest;
        app_push_digest = 1'b1;

        if (app_cfg_q.Type == AppStatic) begin
          if (app_rsp.rsp_valid && app_req.rsp_ready) begin
            st_d = StAppFinish;
          end
        end else begin
          // Ending a session by handshaking the request takes priority over squeezing to avoid
          // starting an obsolete squeeze operation.
          if (app_req.req_valid && app_req.last) begin
            st_d          = StAppFinish;
            app_req_ready = 1'b1;
          end else if (err_sha3_during_app) begin
            st_d = StErrorPush;
          end else if (squeeze_again && !pending_digest_rsp_d) begin
            // Trigger a squeeze if there should be sent more digest parts. Ensure that there
            // is no pending response which would be 'killed' when changing the state.
            cmd_o = CmdManualRun;
            st_d  = StAppWait;
          end
        end
      end

      StAppFinish: begin
        st_d = StAppFinish;

        if (app_cfg_q.Type == AppStatic) begin
          // Immediately end the session for static interfaces.
          st_d      = StIdle;
          cmd_o     = CmdDone;
          clr_appid = 1'b1;
        end else begin
          // Await handshake of pending response from last cycle(s) (digest or error response).
          // Otherwise the finish response would violate the valid locked-in principle.
          app_push_digest     = pending_digest_rsp_q;
          app_error_rsp_valid = pending_error_rsp_q;
          if (!pending_digest_rsp_q && !pending_error_rsp_q) begin
            // We now can send the finish response. Send again the error flag to cover the case the
            // error occurred whilst the last digest response was pending.
            app_finish_rsp_valid    = 1'b1;
            app_finish_rsp_is_error = err_sha3_during_app;

            // Once the finish response is handshaked the session can be ended.
            if (app_finish_rsp_valid && app_req.rsp_ready) begin
              st_d      = StIdle;
              cmd_o     = CmdDone;
              clr_appid = 1'b1;
            end
         end
        end
      end

      StSw: begin
        mux_sel = SelSw;

        cmd_o = sw_cmd_i;
        absorbed_o = absorbed_i;

        if (sw_cmd_i == CmdDone) begin
          st_d = StIdle;
        end else begin
          st_d = StSw;
        end

        // Error out if the key is detected as invalid.
        if (key_used_but_invalid) begin
          st_d = StErrorKeyNotValid;
        end
      end

      StErrorKeyNotValid: begin
        // Signal the error to SW and start the error recovery. This state won't accept any message
        // requests, so we cannot miss the last message part.
        // Note that entering this state could result in a de-asserted valid signal towards the
        // message FIFO / hashing engine if bypassed. This violates the valid locked-in concept but
        // as of now, the FIFO and hashing engine do not strictly require a locked-in valid.
        st_d = StErrorAwaitMsg;

        fsm_err.valid = 1'b 1;
        fsm_err.code = ErrKeyNotValid;
        fsm_err.info = 24'(app_id);
      end

      StErrorAwaitMsg: begin
        // In case of an error, the state machine absorbs all message requests by voiding the
        // received data. Once the last message request has been handshaked an error response is
        // sent. Once the app finished the session and SW also acknowledged the error by writing to
        // the err_processed bit, the hashing engine is then brought back to the idle state by
        // computing a garbage digest.
        //
        // An exception is the service rejected error. In this case no data has ever been sent to
        // the hashing engine and thus it still is in the idle state. The interface still absorbs
        // the full message, sends an error response, waits for a finish request and then returns
        // back to the idle state. No SW interaction is required.
        st_d = StErrorAwaitMsg;

        // Continue to absorb data on the app interface.
        fsm_data_ready = ~err_during_sw_q;

        if (err_during_sw_q) begin
          // Only wait for SW to ack the error.
          st_d = StErrorAwaitSw;
        end else begin
          // Wait for last message part, then send error response in next cycle.
          // The error acknowledgement from SW is latched and checked once the error response has
          // been sent back to the app.
          if (app_req.req_valid && app_req.last) begin
            fsm_digest_done_d = 1'b1;
            st_d              = StErrorNotify;
          end
        end
      end

      StErrorNotify: begin
        // Send error response back to app. Once response is handshaked, wait for finish request
        // (static interfaces don't wait for finish request).
        st_d              = StErrorNotify;
        fsm_digest_done_d = !(app_rsp.rsp_valid && app_req.rsp_ready);

        if (!fsm_digest_done_d) begin
          st_d = app_cfg_q.Type == AppDynamic ? StErrorAwaitFinish : StErrorFinish;
        end
      end

      StErrorAwaitFinish: begin
        // Dynamic only: wait for the app to send a finish request.
        st_d = StErrorAwaitFinish;

        if (app_req.req_valid && app_req.last) begin
          st_d          = StErrorFinish;
          app_req_ready = 1'b1;
        end
      end

      StErrorFinish: begin
        // Send finish response (dynamic) or exit immediately (static).
        // For service-rejected errors, return to idle without SW interaction.
        // For other errors, wait for SW to acknowledge via err_processed.
        st_d = StErrorFinish;

        app_finish_rsp_valid = app_cfg_q.Type == AppDynamic;

        if ((app_finish_rsp_valid && app_req.rsp_ready) || (app_cfg_q.Type == AppStatic)) begin
          if (service_rejected_error) begin
            clr_appid                  = 1'b1;
            clear_after_error_o        = prim_mubi_pkg::MuBi4True;
            service_rejected_error_clr = 1'b1;
            st_d                       = StIdle;
          end else begin
            st_d = StErrorAwaitSw;
          end
        end
      end

      StErrorAwaitSw: begin
        // Wait for SW to have processed the error. This could already have happened thus the flag
        // is latched.
        if (err_processed_d) begin
          // Flush the message FIFO and let the SHA3 engine compute a digest (which won't be used
          // but serves to bring the SHA3 engine back to the idle state).
          cmd_o = CmdProcess;
          st_d  = StErrorAwaitAbsorbed;
        end
      end

      StErrorAwaitAbsorbed: begin
        // Wait until the hashing engine has finished computing the garbage digest.
        if (prim_mubi_pkg::mubi4_test_true_strict(absorbed_i)) begin
          // Clear internal variables, send done command, and return to idle.
          clr_appid                  = 1'b1;
          clear_after_error_o        = prim_mubi_pkg::MuBi4True;
          service_rejected_error_clr = 1'b1;
          cmd_o                      = CmdDone;
          st_d                       = StIdle;
          // If error originated from SW, report 'absorbed' to SW.
          if (err_during_sw_q) begin
            absorbed_o = prim_mubi_pkg::MuBi4True;
          end
        end
      end

      StErrorPush: begin
        // State for dynamic app only.
        // An error occurred while pushing digest parts. Keep sending an error response until the
        // app sends a finish request, then close the session normally.
        st_d              = StErrorPush;

        // Continue sending pending response to adhere to valid locked-in principle.
        if (pending_digest_rsp_q) begin
          app_push_digest = 1'b1;
        end else begin
          // Now continuously send error responses until finish request arrives.
          app_error_rsp_valid = 1'b1;
          if (app_req.req_valid && app_req.last) begin
            app_req_ready = 1'b1;
            st_d          = StAppFinish;
          end
        end
      end

      StTerminalError: begin
        // this state is terminal
        st_d = st;
        sparse_fsm_error_o = 1'b 1;
        fsm_err.valid = 1'b 1;
        fsm_err.code = ErrFatalError;
        fsm_err.info = 24'(app_id);
      end

      default: begin
        st_d = StTerminalError;
        sparse_fsm_error_o = 1'b 1;
      end
    endcase

    // SEC_CM: FSM.GLOBAL_ESC, FSM.LOCAL_ESC
    // Unconditionally jump into the terminal error state
    // if the life cycle controller triggers an escalation.
    if (lc_ctrl_pkg::lc_tx_test_true_loose(lc_escalate_en_i)) begin
      st_d = StTerminalError;
    end

  end

  // Assert that state StErrorPush is only reached if interface is dynamic.
  `ASSERT(StErrorPushDynamic_A, (st == StErrorPush) |-> (app_cfg_q.Type == AppDynamic), 
          clk_i, rst_ni)

  // Track errors occurring in SW mode.
  assign err_during_sw_d =
      (mux_sel == SelSw) && (st_d inside {StErrorAwaitMsg, StErrorKeyNotValid}) ? 1'b1 : // set
      (st_d == StIdle)                                                          ? 1'b0 : // clear
      err_during_sw_q;                                                                   // hold

  // Track SHA3 core errors occurring in app mode. Tracking if already in an error state is not
  // required.
  assign err_sha3_during_app_d =
      (st inside {StAppCfg, StAppMsg, StAppOutLen, StAppProcess,
                  StAppWait, StAppPushDigest, StAppFinish} && error_i) ? 1'b1 : // set
      (st == StIdle)                                                   ? 1'b0 : // clear
      err_sha3_during_app_q;                                                    // hold

  assign err_sha3_during_app = err_sha3_during_app_d | err_sha3_during_app_q;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      err_during_sw_q       <= 1'b0;
      err_sha3_during_app_q <= 1'b0;
    end else begin
      err_during_sw_q       <= err_during_sw_d;
      err_sha3_during_app_q <= err_sha3_during_app_d;
    end
  end

  //////////////
  // Datapath //
  //////////////

  // Encoded output length for the KMAC operation. The length is based upon the full app interface
  // response width.
  assign encoded_outlen      = EncodedOutLen[SelDigSize];
  assign encoded_outlen_strb = EncodedOutLenStrb[SelKeySize];

  // Data mux
  // This is the main part of the app interface logic.
  // The FSM select an app interface in a cycle after it receives the first valid request. The
  // ready signal to the selected app data interface represents the MSG_FIFO ready, only when in
  // the FSM in in the message state. After app has sent the last beat, the interface (to MSG_FIFO)
  // is switched to OutLen. OutLen is a pre-defined value, see `EncodeOutLen` parameter above.

  // EnMasking = 1:
  // - For static and dynamic interface:
  //   - Masked = 0: Forward share 0. Set share 1 to '0.
  //   - Masked = 1: Forward both shares.
  // EnMasking = 0
  // - For static and dynamic interface:
  //   - Masked = 0: Forward share 0. Ignore share 1.
  //   - Masked = 1: Forward XOR of both shares.
  always_comb begin
    app_data_ready = 1'b 0;
    sw_ready_o = 1'b 1; // TODO: Why is this always ready? Shouldn't this be 1'b0?

    kmac_valid_o       = 1'b 0;
    kmac_data_o        = '{default: '0};
    kmac_strb_o        = '0;

    unique case (mux_sel_buf_kmac)
      SelApp: begin
        // Forward message request except app sends empty message to terminate message phase.
        kmac_valid_o   = app_req.req_valid && !app_process_cmd_received;
        if (EnMasking) begin // TODO: make this generic based on Share parameter?
          kmac_data_o[0]     = app_req.data_s0;
          kmac_data_o[1]     = app_cfg_q.Masked ? app_req.data_s1 : '0;
          // TODO: assert Shares = 2 or find another solution
        end else begin
          // If the interface is masked but the KMAC core not, then we unmask the input data.
          // This is save for the masked case because this XOR is removed at compile time if
          // EnMasking is set.
          kmac_data_o[0] = app_cfg_q.Masked ? app_req.data_s0 ^ app_req.data_s1 : app_req.data_s0;
        end
        // Expand byte strobe to bits. prim_packer inside MSG_FIFO accepts a bit mask
        for (int i = 0; i < MsgStrbW; i++) begin
          kmac_strb_o[8*i+:8] = {8{app_req.strb[i]}};
        end
        app_data_ready = kmac_ready_i;
      end

      SelOutLen: begin
        // Write encoded output length value
        kmac_valid_o   = 1'b 1; // always write
        kmac_data_o[0] = MsgWidth'(encoded_outlen);
        if (EnMasking) begin
          // If app interface is masked, the 2nd share is set to '0.
          for (int i = 1; i < Share; i++) begin
            kmac_data_o[i] = '0;
          end
        end
        kmac_strb_o = MsgWidth'(encoded_outlen_strb);
      end

      SelSw: begin
        // SW supports only one share
        kmac_valid_o   = sw_valid_i;
        kmac_data_o[0] = sw_data_i;
        for (int i = 1; i < Share; i++) begin
          kmac_data_o[i] = '0;
        end
        kmac_strb_o    = sw_strb_i;
        sw_ready_o     = kmac_ready_i;
      end

      default: begin // Incl. SelNone
        kmac_valid_o       = 1'b 0;
        kmac_data_o        = '{default: '0};
        kmac_strb_o        = '0;
      end

    endcase
  end

  // Error checking for Mux
  always_comb begin
    mux_err = '{valid: 1'b 0, code: ErrNone, info: '0};

    if (mux_sel_buf_err_check != SelSw && sw_valid_i) begin
      // If SW writes message into FIFO
      mux_err = '{
        valid: 1'b 1,
        code: ErrSwPushedMsgFifo,
        info: 24'({8'h 00, 8'(st), 8'(mux_sel_buf_err_check)})
      };
    end else if (app_active_o && sw_cmd_i != CmdNone) begin
      // If SW issues command except start
      mux_err = '{
        valid: 1'b 1,
        code: ErrSwIssuedCmdInAppActive,
        info: 24'(sw_cmd_i)
      };
    end
  end

  logic [AppMuxWidth-1:0] mux_sel_buf_output_logic;
  assign mux_sel_buf_output = app_mux_sel_e'(mux_sel_buf_output_logic);

  // SEC_CM: LOGIC.INTEGRITY
  prim_sec_anchor_buf #(
   .Width(AppMuxWidth)
  ) u_prim_buf_state_output_sel (
    .in_i(mux_sel),
    .out_o(mux_sel_buf_output_logic)
  );

  logic [AppMuxWidth-1:0] mux_sel_buf_err_check_logic;
  assign mux_sel_buf_err_check = app_mux_sel_e'(mux_sel_buf_err_check_logic);

  // SEC_CM: LOGIC.INTEGRITY
  prim_sec_anchor_buf #(
   .Width(AppMuxWidth)
  ) u_prim_buf_state_err_check (
    .in_i(mux_sel),
    .out_o(mux_sel_buf_err_check_logic)
  );

  logic [AppMuxWidth-1:0] mux_sel_buf_kmac_logic;
  assign mux_sel_buf_kmac = app_mux_sel_e'(mux_sel_buf_kmac_logic);

  // SEC_CM: LOGIC.INTEGRITY
  prim_sec_anchor_buf #(
   .Width(AppMuxWidth)
  ) u_prim_buf_state_kmac_sel (
    .in_i(mux_sel),
    .out_o(mux_sel_buf_kmac_logic)
  );

  // SEC_CM: LOGIC.INTEGRITY
  logic reg_state_valid;
  prim_sec_anchor_buf #(
   .Width(1)
  ) u_prim_buf_state_output_valid (
    .in_i(reg_state_valid),
    .out_o(reg_state_valid_o)
  );

  // Keccak state Demux
  // Keccak state --> Register output is enabled when state is in StSw
  always_comb begin
    reg_state_valid = 1'b 0;
    reg_state_o = '{default:'0};
    if ((mux_sel_buf_output == SelSw) &&
         lc_ctrl_pkg::lc_tx_test_false_strict(lc_escalate_en_i)) begin
      reg_state_valid = keccak_state_valid_i;
      reg_state_o = keccak_state_i;
      // If key is sideloaded and KMAC is SW initiated
      // hide the capacity from SW by zeroing (see #17508)
      if (keymgr_key_en_i) begin
        for (int i = 0; i < Share; i++) begin
          unique case (keccak_strength_o)
            L128: reg_state_o[i][sha3_pkg::StateW-1-:KeccakBitCapacity[L128]] = '0;
            L224: reg_state_o[i][sha3_pkg::StateW-1-:KeccakBitCapacity[L224]] = '0;
            L256: reg_state_o[i][sha3_pkg::StateW-1-:KeccakBitCapacity[L256]] = '0;
            L384: reg_state_o[i][sha3_pkg::StateW-1-:KeccakBitCapacity[L384]] = '0;
            L512: reg_state_o[i][sha3_pkg::StateW-1-:KeccakBitCapacity[L512]] = '0;
            default: reg_state_o[i] = '0;
          endcase
        end
      end
    end
  end

  ///////////////////
  // Digest pusher //
  ///////////////////
  // The maximal number of digest chunks is defined by the operation with the largest rate.
  // And as SHA3, SHAKE, cSHAKE and KMAC have always a state width of 1600 the largest rate has
  // SHAKE-128 / cSHAKE-128 / KMAC-128.
  localparam int MaxNumDigestParts = (sha3_pkg::StateW - 2 * 128) / DynAppDigestW;
  localparam int DigestCntW        = $clog2(MaxNumDigestParts);
  logic [DigestCntW-1:0] digest_top;
  logic [DigestCntW-1:0] current_digest_idx;

  // Expose only the relevant part of the digest depending on the mode and strength. In case an
  // invalid mode or strength is detected, we set the digest_top to the smallest value.
  always_comb begin
    unique case (sha3_mode_o)
      sha3_pkg::Sha3: begin
        unique case (keccak_strength_o)
          sha3_pkg::L128: digest_top = DigestCntW'(128 / DynAppDigestW);
          // 224 is not a multiple of 64. Round up the number of digest parts. Note, due to this
          // rounding the interface exposes bits from the rate which are not part of the hash.
          sha3_pkg::L224: digest_top = DigestCntW'(4);
          sha3_pkg::L256: digest_top = DigestCntW'(256 / DynAppDigestW);
          sha3_pkg::L384: digest_top = DigestCntW'(384 / DynAppDigestW);
          sha3_pkg::L512: digest_top = DigestCntW'(512 / DynAppDigestW);
          default:        digest_top = DigestCntW'(128 / DynAppDigestW);
        endcase
      end
      sha3_pkg::Shake,
      sha3_pkg::CShake: begin
        // Expose the full rate for SHAKE, cSHAKE and KMAC. It is save to expose the full rate of
        // KMAC even if it exceeds the encoded output length.
        unique case (keccak_strength_o)
          sha3_pkg::L128: digest_top = DigestCntW'((sha3_pkg::StateW - 2 * 128) / DynAppDigestW);
          sha3_pkg::L224: digest_top = DigestCntW'((sha3_pkg::StateW - 2 * 224) / DynAppDigestW);
          sha3_pkg::L256: digest_top = DigestCntW'((sha3_pkg::StateW - 2 * 256) / DynAppDigestW);
          sha3_pkg::L384: digest_top = DigestCntW'((sha3_pkg::StateW - 2 * 384) / DynAppDigestW);
          sha3_pkg::L512: digest_top = DigestCntW'((sha3_pkg::StateW - 2 * 512) / DynAppDigestW);
          default:        digest_top = DigestCntW'((sha3_pkg::StateW - 2 * 512) / DynAppDigestW);
        endcase
      end
      default: digest_top = DigestCntW'(128 / DynAppDigestW);
    endcase
  end

  // Limit the response width to 64 bits because its the GCD for all modes except SHA-224.
  `ASSERT_INIT(DynAppDigestWIs64Bit_A, DynAppDigestW == 64)
  // Ensure all counter top computations divide properly as the response channel does not carry any
  // valid-strobe information.
  `ASSERT_INIT(DigestTopDividesSha3L128_A, 128 % DynAppDigestW == 0)
  // An exception is SHA3-224, where we fix the number of digest parts to 4, so the full hash and
  // some additional rate bits are sent.
  `ASSERT_INIT(DigestTopDividesSha3L256_A, 256 % DynAppDigestW == 0)
  `ASSERT_INIT(DigestTopDividesSha3L384_A, 384 % DynAppDigestW == 0)
  `ASSERT_INIT(DigestTopDividesSha3L512_A, 512 % DynAppDigestW == 0)

  `ASSERT_INIT(DigestTopDividesKmacAppDigestW_A, AppDigestW % DynAppDigestW == 0)

  `ASSERT_INIT(DigestTopDividesShakeL128_A, (sha3_pkg::StateW - 2 * 128) % DynAppDigestW == 0)
  `ASSERT_INIT(DigestTopDividesShakeL224_A, (sha3_pkg::StateW - 2 * 224) % DynAppDigestW == 0)
  `ASSERT_INIT(DigestTopDividesShakeL256_A, (sha3_pkg::StateW - 2 * 256) % DynAppDigestW == 0)
  `ASSERT_INIT(DigestTopDividesShakeL384_A, (sha3_pkg::StateW - 2 * 384) % DynAppDigestW == 0)
  `ASSERT_INIT(DigestTopDividesShakeL512_A, (sha3_pkg::StateW - 2 * 512) % DynAppDigestW == 0)

  // TODO: Is != sufficient or should we use < ? (!= should require slightly less area).
  assign digest_parts_available = current_digest_idx != digest_top;

  // Send parts of the digest if we are pushing.
  // Gate with digest_parts_available to prevent sending capacity-region bits when
  // current_digest_idx has already reached digest_top (the rate boundary).
  // Also do not send a digest if the counter top valid is not valid
  assign app_digest_valid = app_push_digest && digest_parts_available &&
                            lc_ctrl_pkg::lc_tx_test_false_strict(lc_escalate_en_i);

  // Only allow a squeeze if the app allows it.
  logic squeeze_again_allowed;
  assign squeeze_again_allowed = app_cfg_q.Type == AppDynamic && app_cfg_q.EnXof;

  // Request a squeeze once we are out of digest parts.
  assign squeeze_again = squeeze_again_allowed && !digest_parts_available;

  logic digest_part_pushed;
  assign digest_part_pushed = app_digest_valid && app_req.rsp_ready;

  // Register if there is a digest response pending. If so, the finish response must wait until the
  // currently pending response is accepted. Otherwise we would change data after the valid was
  // asserted which violates the valid locked-in property.
  assign pending_digest_rsp_d = app_digest_valid && !digest_part_pushed;

  // Similarly, register if there is a pending error response.
  logic error_rsp_pushed;
  assign error_rsp_pushed    = app_error_rsp_valid && app_req.rsp_ready;
  assign pending_error_rsp_d = app_error_rsp_valid && !error_rsp_pushed;

  // TODO: Do we have to guard the capacity? Especially for SHA3-224 as we push bits outside of the
  //       actual digest.
  logic [DynAppDigestW-1:0] digest_part[Share];
  for (genvar i = 0; i < Share; i++) begin
    assign digest_part[i] = keccak_state_i[i][DynAppDigestW * current_digest_idx +: DynAppDigestW];
  end

  always_comb begin
    app_digest = '{default:'0};
    if (app_digest_valid) begin
      // Digest has always 2 entries. If !EnMasking, second is tied to 0.
      for (int i = 0 ; i < Share ; i++) begin
        // Return the portion of state.
        if (app_cfg_q.Type == AppStatic) begin
          app_digest[i] = keccak_state_i[i][AppDigestW-1:0];
        end else if (app_cfg_q.Type == AppDynamic) begin
          // Only expose a sub part
          app_digest[i][DynAppDigestW-1:0] = digest_part[i];
        end
        // Faulted app type exposes '0
      end
    end
  end

  // SEC_CM CTR.REDUN
  prim_count #(
    .Width(DigestCntW)
  ) u_digest_part_counter (
    .clk_i,
    .rst_ni,
    .clr_i             (reset_digest_pusher),
    .set_i             (1'b0),
    .set_cnt_i         ('0),
    .incr_en_i         (1'b1),
    .decr_en_i         (1'b0),
    .step_i            (DigestCntW'(1)),
    .commit_i          (digest_part_pushed || reset_digest_pusher),
    .cnt_o             (current_digest_idx),
    .cnt_after_commit_o(),
    .err_o             (counter_error_o)
  );

  //////////////////
  // Key handling //
  //////////////////

  // Secret Key Mux
  // Prepare merged key if EnMasking is not set.
  // Combine share keys into unpacked array for logic below to assign easily.
  // SEC_CM: KEY.SIDELOAD
  logic [MaxKeyLen-1:0] keymgr_key[Share];
  if (EnMasking == 1) begin : g_masked_key
    for (genvar i = 0; i < Share; i++) begin : gen_key_pad
      assign keymgr_key[i] =  {(MaxKeyLen-KeyMgrKeyW)'(0), keymgr_key_i.key[i]};
    end
  end else begin : g_unmasked_key
    always_comb begin
      keymgr_key[0] = '0;
      for (int i = 0; i < keymgr_pkg::Shares; i++) begin
        keymgr_key[0][KeyMgrKeyW-1:0] ^= keymgr_key_i.key[i];
      end
    end
  end

  // Sideloaded key expose control
  assign key_used_but_invalid = keymgr_key_used && !keymgr_key_i.valid;

  always_comb begin
    keymgr_key_used = 1'b0;
    key_len_o  = reg_key_len_i;
    for (int i = 0 ; i < Share; i++) begin
      key_data_o[i] = reg_key_data_i[i];
    end
    // The key is considered invalid in all cases that are not listed below (which includes idle and
    // error states).
    key_valid_o = 1'b0;

    unique case (st)
      StAppMsg: begin
        // The key from keymgr is used if the current HW app interface does *keyed* MAC. We
        // consider the key only valid as long as the hashing engine actually uses the key, i.e.,
        // at the start of the message absorb phase. Once the processing has started the key is no
        // longer used.
        keymgr_key_used = app_cfg_q.Mode == AppKMAC;
        key_len_o = SideloadedKey;
        for (int i = 0 ; i < Share; i++) begin
          key_data_o[i] = keymgr_key[i];
        end
        // Key is valid if the current HW app interface does *keyed* MAC and the key provided by
        // keymgr is valid.
        key_valid_o = keymgr_key_used && keymgr_key_i.valid;
      end

      StSw: begin
        if (keymgr_key_en_i) begin
          // Key from keymgr is actually used if *keyed* MAC is enabled.
          keymgr_key_used = kmac_en_o;
          key_len_o = SideloadedKey;
          for (int i = 0 ; i < Share; i++) begin
            key_data_o[i] = keymgr_key[i];
          end
        end
        // Key is valid if SW does *keyed* MAC and ...
        if (kmac_en_o) begin
          if (!keymgr_key_en_i) begin
            // ... it uses the key from kmac's CSR, or ...
            key_valid_o = 1'b1;
          end else begin
            // ... it uses the key provided by keymgr and that one is valid.
            key_valid_o = keymgr_key_i.valid;
          end
        end
      end

      default: ;
    endcase
  end

  // Prefix Demux
  // For SW, always prefix register.
  // For App intf, check PrefixMode cfg and if 1, use Prefix cfg.
  always_comb begin
    sha3_prefix_o = '0;

    unique case (st)
      StAppCfg, StAppMsg, StAppOutLen, StAppProcess, StAppWait, StAppPushDigest: begin
        if (app_cfg_q.PrefixMode == 1'b 0) begin
              sha3_prefix_o = reg_prefix_i;
            end else begin
              sha3_prefix_o = app_cfg_q.Prefix;
            end
      end

      StSw: begin
        sha3_prefix_o = reg_prefix_i;
      end

      default: begin
        sha3_prefix_o = reg_prefix_i;
      end
    endcase
  end

  // KMAC en / SHA3 mode / Strength / configuration latching
  // by default, it uses reg cfg. When app intf reqs come, it uses AppCfg.
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      app_cfg_q         <= AppCfgDefault; // What should we use as default?
      kmac_en_o         <= 1'b 0;
      sha3_mode_o       <= sha3_pkg::Sha3;
      keccak_strength_o <= sha3_pkg::L256;
    end else if (clr_appid) begin
      // As App completed, latch reg value
      app_cfg_q         <= AppCfgDefault; // has no effect
      kmac_en_o         <= reg_kmac_en_i;
      sha3_mode_o       <= reg_sha3_mode_i;
      keccak_strength_o <= reg_keccak_strength_i;
    end else if (set_appid) begin
      app_cfg_q         <= app_cfg_d;
      kmac_en_o         <= app_cfg_d.Mode == AppKMAC ? 1'b 1 : 1'b 0;
      // KMAC is based upon CShake
      sha3_mode_o       <= app_cfg_d.Mode == AppSHA3  ? sha3_pkg::Sha3  :
                           app_cfg_d.Mode == AppShake ? sha3_pkg::Shake : sha3_pkg::CShake;
      keccak_strength_o <= app_cfg_d.KeccakStrength;
    end else if (st == StIdle) begin
      app_cfg_q         <= AppCfgDefault;
      kmac_en_o         <= reg_kmac_en_i;
      sha3_mode_o       <= reg_sha3_mode_i;
      keccak_strength_o <= reg_keccak_strength_i;
    end
  end

  // Status
  assign app_active_o = (st inside {StAppCfg, StAppMsg, StAppOutLen, StAppProcess, StAppWait,
                                    StAppPushDigest, StAppFinish});

  // Error Reporting ==========================================================
  always_comb begin
    priority casez ({fsm_err.valid, mux_err.valid})
      2'b ?1: error_o = mux_err;
      2'b 10: error_o = fsm_err;
      default: error_o = '{valid: 1'b0, code: ErrNone, info: '0};
    endcase
  end

  ////////////////
  // Assertions //
  ////////////////

  // KeyMgr sideload key and the digest should be in the Key Length value
  `ASSERT_INIT(SideloadKeySameToDigest_A, KeyMgrKeyW <= AppDigestW)
  `ASSERT_INIT(AppIntfInRange_A, AppDigestW inside {128, 192, 256, 384, 512})

  // Issue(#13655): Having a coverage that sideload keylen and CSR keylen are
  // different.
  `COVER(AppIntfUseDifferentSizeKey_C,
    (st == StAppCfg && kmac_en_o) |-> reg_key_len_i != SideloadedKey)

endmodule
