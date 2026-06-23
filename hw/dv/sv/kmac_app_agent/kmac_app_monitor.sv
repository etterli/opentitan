// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class kmac_app_monitor extends dv_reactive_monitor #(
    .ITEM_T (kmac_app_item),
    .CFG_T  (kmac_app_agent_cfg),
    .COV_T  (kmac_app_agent_cov)
  );
  `uvm_component_utils(kmac_app_monitor)

  // the base class provides the following handles for use:
  // kmac_app_agent_cfg: cfg
  // kmac_app_agent_cov: cov
  // uvm_analysis_port #(kmac_app_item): analysis_port

  uvm_tlm_analysis_fifo#(push_pull_item#(`CONNECT_DATA_WIDTH))     data_fifo;
  uvm_tlm_analysis_fifo#(push_pull_item#(`RSP_CONNECT_DATA_WIDTH)) rsp_data_fifo;

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    data_fifo     = new("data_fifo",     this);
    rsp_data_fifo = new("rsp_data_fifo", this);
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

  // Static mode: collect message beats until last=1, then wait for one response.
  virtual protected task process_static_trans();
    forever begin
      kmac_app_item req = kmac_app_item::type_id::create("req");
      kmac_app_item rsp;
      req.app_type = AppStatic;

      collect_message_beats(req);
      req_analysis_port.write(req);
      `uvm_info(`gfn, $sformatf("Static req:\n%0s", req.sprint()), UVM_HIGH)

      `downcast(rsp, req.clone())
      begin
        push_pull_item#(`RSP_CONNECT_DATA_WIDTH) rsp_item;
        logic [kmac_pkg::AppDigestW-1:0] share0, share1;
        logic err, fin;
        rsp_data_fifo.get(rsp_item);
        {share0, share1, err, fin} = rsp_item.h_data;
        `DV_CHECK_EQ(fin, 1'b0, "Static app interface must never assert rsp_finished")
        rsp.digest_s0 = share0;
        rsp.digest_s1 = share1;
        rsp.error     = err;
      end
      analysis_port.write(rsp);
      `uvm_info(`gfn, $sformatf("Static rsp:\n%0s", rsp.sprint()), UVM_HIGH)
      ok_to_end = 1;
    end
  endtask

  // Dynamic mode:
  //   1. Config beat  : First push_pull item; extract mode/strength from data_s0.
  //   2. Message beats: Collect until last=1.
  //   3. Digest stream: KMAC pushes req_output_len chunks. Collect them all.
  //   4. Finish beat  : One push_pull item with last=1 sent by the host after receiving enough
  //                     chunks.
  //   5. Session end  : Discard any remaining response until a response with finished=1 arrives.
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
        kmac_pkg::app_ses_config_t ses_cfg;
        ok_to_end = 1;
        data_fifo.get(cfg_item);
        {data, strb, last} = cfg_item.h_data;
        ses_cfg = kmac_pkg::app_ses_config_t'(data);
        req.app_type = AppDynamic;
        `uvm_info(`gfn, $sformatf("Session config beat: mode=%0s strength=%0s en_xof=%0b",
                                   ses_cfg.mode.name(), ses_cfg.kstrength.name(), ses_cfg.en_xof),
                  UVM_HIGH)
      end

      // Message beats.
      collect_message_beats(req);
      req_analysis_port.write(req);
      `uvm_info(`gfn, $sformatf("Dynamic req:\n%0s", req.sprint()), UVM_HIGH)

      `downcast(rsp, req.clone())

      // Digest stream: collect exactly req_output_len chunks pushed by KMAC.
      // Each fifo item represents one completed valid/ready handshake.
      for (int i = 0; i < int'(cfg.req_output_len); i++) begin
        push_pull_item#(`RSP_CONNECT_DATA_WIDTH) rsp_item;
        logic [kmac_pkg::AppDigestW-1:0] share0, share1;
        logic err, fin;
        rsp_data_fifo.get(rsp_item);
        {share0, share1, err, fin} = rsp_item.h_data;
        rsp.digest_chunks_s0.push_back(share0[DynAppDigestW-1:0]);
        rsp.digest_chunks_s1.push_back(share1[DynAppDigestW-1:0]);
      end

      // Drain the finish beat (last=1) sent by the host after collecting enough chunks.
      begin
        push_pull_item#(`CONNECT_DATA_WIDTH) finish_item;
        data_fifo.get(finish_item);
      end

      // Wait for session-end: drain rsp_data_fifo until an item with rsp_finished=1 arrives.
      // KMAC may push extra chunks before asserting finished; we discard them.
      begin
        push_pull_item#(`RSP_CONNECT_DATA_WIDTH) rsp_item;
        logic [kmac_pkg::AppDigestW-1:0] share0, share1;
        logic err, fin;
        do begin
          rsp_data_fifo.get(rsp_item);
          {share0, share1, err, fin} = rsp_item.h_data;
        end while (fin !== 1'b1);
        rsp.error    = err;
        rsp.finished = fin;
      end
      analysis_port.write(rsp);
      `uvm_info(`gfn, $sformatf("Dynamic rsp (%0d chunks):\n%0s",
                                  rsp.digest_chunks_s0.size(), rsp.sprint()), UVM_HIGH)
      ok_to_end = 1;
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
    rsp_data_fifo.flush();
  endtask

endclass
