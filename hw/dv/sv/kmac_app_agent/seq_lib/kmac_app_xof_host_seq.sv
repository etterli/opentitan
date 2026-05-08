// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Host sequence for AppDynamic (OTBN) XOF transactions.
//
// Transaction flow:
//   Phase 0 – Config beat:   one push_pull beat encoding mode/strength as data.
//   Phase 1 – Message beats: drive message bytes.
//   Phase 2 – Digest:        KMAC pushes req_output_len chunks (rsp_valid pulses) without
//                            per-chunk requests.  Once all chunks are received the host
//                            sends a single finish beat (last=1).  Any further rsp_valid
//                            pulses are discarded until rsp_finished signals session end.
class kmac_app_xof_host_seq extends kmac_app_base_seq;
  `uvm_object_utils(kmac_app_xof_host_seq)
  `uvm_object_new

  // Message to hash.  Must be set before starting this sequence.
  byte msg_q[$];

  // Number of 64-bit digest chunks to request.
  int unsigned req_output_len = 8;

  virtual task body();
    cfg.m_data_push_agent_cfg.zero_delays = cfg.zero_delays;

    // Phase 0: config beat.
    // Bit 20 = EnXof: enable multi-squeeze for SHAKE/CShake XOF modes.
    begin
      bit en_xof = cfg.app_mode inside {kmac_pkg::AppShake, kmac_pkg::AppCShake};
      send_one_beat(.data({KmacDataIfWidth'(0) |
                           (KmacDataIfWidth'(cfg.app_mode) << 10) |
                           (KmacDataIfWidth'(en_xof) << 20) |
                           KmacDataIfWidth'(cfg.app_strength)}),
                    .strb('1), .last(1'b0));
    end

    // Phase 1: message beats.
    begin
      byte local_msg[$] = msg_q;
      while (1) begin
        bit [KmacDataIfWidth-1:0]   beat_data = '0;
        bit [KmacDataIfWidth/8-1:0] beat_strb = '0;
        bit                         beat_last;
        int bytes_sent = 0;

        for (int i = 0; i < KmacDataIfWidth / 8; i++) begin
          if (local_msg.size() == 0) break;
          beat_data[i*8 +: 8] = local_msg.pop_front();
          beat_strb[i] = 1;
          bytes_sent++;
        end

        if (bytes_sent == 0) begin
          // Empty message: one beat with strb='1, last=1.
          beat_strb = '1;
        end

        beat_last = (local_msg.size() == 0);
        send_one_beat(.data(beat_data), .strb(beat_strb), .last(beat_last));
        if (beat_last) break;
      end
    end

    // Phase 2: receive digest chunks pushed by KMAC, then send finish.
    // Back pressure on rsp_ready is handled automatically by the push_pull device driver.
    for (int i = 0; i < int'(req_output_len); i++) begin
      wait_rsp_valid();
    end

    // Signal to KMAC that enough digest data has been received.
    send_one_beat(.data('0), .strb('1), .last(1'b1));

    // Drain any extra chunks in the pipeline before the finish response arrives.
    wait_rsp_finished();
  endtask

  // Drive a single push-pull beat by adding to the push-pull host's user-data
  // queue and running a one-shot push_pull_host_seq.
  virtual task send_one_beat(
      input bit [KmacDataIfWidth-1:0]   data,
      input bit [KmacDataIfWidth/8-1:0] strb,
      input bit                         last
  );
    push_pull_host_seq#(`CONNECT_DATA_WIDTH) host_seq;
    `uvm_create_on(host_seq, p_sequencer.m_push_pull_sequencer)
    `DV_CHECK_RANDOMIZE_FATAL(host_seq)
    cfg.m_data_push_agent_cfg.add_h_user_data({data, strb, last});
    `uvm_send(host_seq)
  endtask

  // Wait for one rsp_valid/rsp_ready handshake transfer.
  virtual task wait_rsp_valid();
    while (!(cfg.vif.mon_cb.rsp_valid === 1 && cfg.vif.mon_cb.rsp_ready === 1))
      @(cfg.vif.mon_cb);
    @(cfg.vif.mon_cb);
  endtask

  // Wait for the session-end handshake: a completed transfer with rsp_finished asserted.
  virtual task wait_rsp_finished();
    while (!(cfg.vif.mon_cb.rsp_valid === 1 && cfg.vif.mon_cb.rsp_ready === 1 &&
             cfg.vif.mon_cb.rsp_finished === 1))
      @(cfg.vif.mon_cb);
    @(cfg.vif.mon_cb);
  endtask

endclass
