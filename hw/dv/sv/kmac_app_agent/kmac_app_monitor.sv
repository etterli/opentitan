// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class kmac_app_monitor extends dv_base_monitor #(
    .ITEM_T (kmac_app_item),
    .CFG_T  (kmac_app_agent_cfg),
    .COV_T  (kmac_app_agent_cov)
  );
  `uvm_component_utils(kmac_app_monitor)

  // the base class provides the following handles for use:
  // kmac_app_agent_cfg: cfg
  // kmac_app_agent_cov: cov
  // uvm_analysis_port #(kmac_app_item): analysis_port

  uvm_tlm_analysis_fifo#(push_pull_item#(`CONNECT_DATA_WIDTH)) data_fifo;

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    data_fifo = new("data_fifo", this);
  endfunction

  virtual protected task collect_trans();
    forever fork
      begin : isolation_fork
        fork
          process_trans();
          @(negedge cfg.vif.rst_n);
        join_any
        disable fork;
        process_reset();
      end : isolation_fork
    join
  endtask

  virtual protected task process_trans();
    if (cfg.app_type == AppDynamic) begin
      process_dynamic_trans();
    end else begin
      process_static_trans();
    end
  endtask

  // Static mode: collect message beats until last=1, then wait for one rsp_done.
  virtual protected task process_static_trans();
    forever begin
      kmac_app_item req = kmac_app_item::type_id::create("req");
      kmac_app_item rsp;
      req.app_type = AppStatic;

      collect_message_beats(req);
      req_analysis_port.write(req);
      `uvm_info(`gfn, $sformatf("Static req:\n%0s", req.sprint()), UVM_HIGH)

      `downcast(rsp, req.clone())
      while (cfg.vif.rsp_done !== 1) @(cfg.vif.mon_cb);
      rsp.rsp_error         = cfg.vif.rsp_error;
      rsp.rsp_digest_share0 = cfg.vif.rsp_digest_share0;
      rsp.rsp_digest_share1 = cfg.vif.rsp_digest_share1;
      analysis_port.write(rsp);
      `uvm_info(`gfn, $sformatf("Static rsp:\n%0s", rsp.sprint()), UVM_HIGH)
      ok_to_end = 1;
    end
  endtask

  // Dynamic mode (AppOtbn):
  //   1. Config beat  – first push_pull item; extract mode/strength from data_s0.
  //   2. Message beats – collect until last=1.
  //   3. Digest stream – for each req beat (req_output_len total), collect one
  //      64-bit rsp_done pulse.  The final beat's rsp_done is the finish pulse
  //      (no data appended).
  virtual protected task process_dynamic_trans();
    forever begin
      kmac_app_item req = kmac_app_item::type_id::create("req");
      kmac_app_item rsp;
      req.app_type      = AppDynamic;
      req.req_output_len = cfg.req_output_len;

      // Config beat: skip bytes, record mode/strength.
      begin
        bit [KmacDataIfWidth-1:0] data;
        bit [KmacDataIfWidth/8-1:0] strb;
        bit last;
        push_pull_item#(`CONNECT_DATA_WIDTH) cfg_item;
        ok_to_end = 1;
        data_fifo.get(cfg_item);
        {data, strb, last} = cfg_item.h_data;
        req.app_type = AppDynamic;
        `uvm_info(`gfn, $sformatf("Dynamic config beat: mode=%0d strength=%0d",
                                   data[11:10], data[2:0]), UVM_HIGH)
      end

      // Message beats.
      collect_message_beats(req);
      req_analysis_port.write(req);
      `uvm_info(`gfn, $sformatf("Dynamic req:\n%0s", req.sprint()), UVM_HIGH)

      `downcast(rsp, req.clone())

      // Digest stream: collect exactly req_output_len data chunks.
      // Each chunk arrives on a separate rsp_done pulse.  The finish pulse
      // (app_finish_rsp_valid, no digest data) fires after the last=1 request
      // beat, which is sent after this loop, so the loop never sees it.
      for (int i = 0; i < int'(cfg.req_output_len); i++) begin
        while (cfg.vif.rsp_done !== 1) @(cfg.vif.mon_cb);
        rsp.digest_chunks_s0.push_back(cfg.vif.rsp_digest_share0[DynAppDigestW-1:0]);
        rsp.digest_chunks_s1.push_back(cfg.vif.rsp_digest_share1[DynAppDigestW-1:0]);
        @(cfg.vif.mon_cb);
        while (cfg.vif.rsp_done !== 0) @(cfg.vif.mon_cb);
      end

      rsp.rsp_error = cfg.vif.rsp_error;
      analysis_port.write(rsp);
      `uvm_info(`gfn, $sformatf("Dynamic rsp (%0d chunks):\n%0s",
                                  rsp.digest_chunks_s0.size(), rsp.sprint()), UVM_HIGH)
      ok_to_end = 1;

      // The Phase-2 digest request beats (req_output_len beats) were driven
      // via the push_pull interface and recorded in data_fifo by the push_pull
      // monitor.  Drain them here so they are not mistaken for the config beat
      // of the next transaction.
      begin
        push_pull_item#(`CONNECT_DATA_WIDTH) drain_item;
        for (int i = 0; i < int'(cfg.req_output_len); i++) begin
          data_fifo.get(drain_item);
        end
      end
    end
  endtask

  // Collect push_pull message beats until last=1, appending bytes into item.
  virtual protected task collect_message_beats(kmac_app_item item);
    while (1) begin
      bit [KmacDataIfWidth-1:0]   data;
      bit [KmacDataIfWidth/8-1:0] strb;
      bit                         last;
      push_pull_item#(`CONNECT_DATA_WIDTH) data_item;

      ok_to_end = 1;
      data_fifo.get(data_item);
      {data, strb, last} = data_item.h_data;

      for (int i = 0; i < KmacDataIfWidth/8; i++) begin
        if (strb[i]) item.byte_data_q.push_back(data[i*8+:8]);
      end

      if (last) begin
        ok_to_end = 0;
        break;
      end
    end
  endtask

  virtual protected task process_reset();
    `uvm_info(`gfn, $sformatf("Reset occurs"), UVM_MEDIUM)
    ok_to_end = 1;
    @(posedge cfg.vif.rst_n);
    data_fifo.flush();
  endtask

endclass
