// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Host sequence for AppDynamic (OTBN) XOF transactions.
//
// Transaction flow:
//   Phase 0 – Config beat:  one push_pull beat encoding mode/strength in data[11:10]/[2:0].
//   Phase 1 – Message beats: drive message bytes.
//   Phase 2 – Digest loop:   req_output_len beats; wait for rsp_done between each.
//                             The final beat uses last=1 to terminate the session.
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
    send_one_beat(.data({KmacDataIfWidth'(0) |
                         (KmacDataIfWidth'(cfg.app_mode) << 10) |
                         KmacDataIfWidth'(cfg.app_strength)}),
                  .strb('1), .last(1'b0));

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

    // Phase 2: digest request loop.
    // Wait for the first chunk before driving any request, to satisfy the
    // DoneAssertAfterLast_A interface assertion (no req_valid between message
    // last and the first rsp_done).
    wait_rsp_done();

    for (int i = 0; i < int'(req_output_len); i++) begin
      bit last_chunk = (i == int'(req_output_len) - 1);
      send_one_beat(.data('0), .strb('1), .last(last_chunk));
      if (!last_chunk) wait_rsp_done();
    end
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

  // Wait for rsp_done to assert then deassert (one pulse).
  virtual task wait_rsp_done();
    while (cfg.vif.rsp_done !== 1) @(cfg.vif.mon_cb);
    @(cfg.vif.mon_cb);
    while (cfg.vif.rsp_done !== 0) @(cfg.vif.mon_cb);
  endtask

endclass
