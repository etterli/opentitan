// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class kmac_app_device_driver extends kmac_app_driver;
  `uvm_component_utils(kmac_app_device_driver)
  `uvm_component_new

  task on_enter_reset();
    // Response signals are driven through the m_rsp_push_agent push_pull sub-agent. As of this
    // there is nothing to invalidate directly here.
  endtask

  // drive trans received from sequencer
  virtual task get_and_drive();
    forever begin
      push_pull_host_seq#(`RSP_CONNECT_DATA_WIDTH) rsp_seq;
      bit [kmac_app_agent_pkg::KMAC_RSP_DATA_WIDTH-1:0] h_data;

      seq_item_port.get_next_item(req);
      $cast(rsp, req.clone());
      rsp.set_id_info(req);
      `uvm_info(`gfn, $sformatf("rcvd item:\n%0s", req.sprint()), UVM_HIGH)

      if (req.app_type == kmac_pkg::AppDynamic) begin
        // Wait for config beat: req_valid=1, last=0.
        while (!(cfg.vif.kmac_data_req.req_valid && !cfg.vif.kmac_data_req.req_last))
          @(posedge cfg.vif.clk);

        // Advance past config beat, then wait for last message beat: req_valid=1, req_last=1.
        @(posedge cfg.vif.clk);
        while (!(cfg.vif.kmac_data_req.req_valid && cfg.vif.kmac_data_req.req_last))
          @(posedge cfg.vif.clk);

        // Send all digest chunks with finished=0. Each 64-bit chunk is placed in the
        // lower DynAppDigestW bits of the 384-bit share field; upper bits are zero.
        for (int i = 0; i < req.digest_chunks_s0.size(); i++) begin
          h_data = {
            {(kmac_pkg::AppDigestW - kmac_pkg::DynAppDigestW){1'b0}}, req.digest_chunks_s0[i],
            {(kmac_pkg::AppDigestW - kmac_pkg::DynAppDigestW){1'b0}}, req.digest_chunks_s1[i],
            req.error, 1'b0};
          cfg.m_rsp_push_agent_cfg.add_h_user_data(h_data);
          rsp_seq = push_pull_host_seq#(`RSP_CONNECT_DATA_WIDTH)::type_id::create("rsp_seq");
          `DV_CHECK_RANDOMIZE_FATAL(rsp_seq)
          rsp_seq.start(cfg.m_rsp_push_sequencer);
        end

        // Wait for finish beat from DUT: req_valid=1, last=1 again (after chunk reception).
        @(posedge cfg.vif.clk);
        while (!(cfg.vif.kmac_data_req.req_valid && cfg.vif.kmac_data_req.req_last))
          @(posedge cfg.vif.clk);

        // Send session-end response with finished=1.
        h_data = {'0, req.error, 1'b1};
        cfg.m_rsp_push_agent_cfg.add_h_user_data(h_data);
        rsp_seq = push_pull_host_seq#(`RSP_CONNECT_DATA_WIDTH)::type_id::create("rsp_seq");
        `DV_CHECK_RANDOMIZE_FATAL(rsp_seq)
        rsp_seq.start(cfg.m_rsp_push_sequencer);
      end else begin
        // AppStatic: single full-width digest. The push_pull host seq drives rsp_valid/h_data
        // and waits for rsp_ready (fed back from kmac_data_req.rsp_ready via rsp_data_if.ready).
        // host_delay_min/max (set from rsp_delay_min/max) provide the response latency.
        h_data = {rsp.digest_s0, rsp.digest_s1, rsp.error, 1'b0};
        cfg.m_rsp_push_agent_cfg.add_h_user_data(h_data);
        rsp_seq = push_pull_host_seq#(`RSP_CONNECT_DATA_WIDTH)::type_id::create("rsp_seq");
        `DV_CHECK_RANDOMIZE_FATAL(rsp_seq)
        rsp_seq.start(cfg.m_rsp_push_sequencer);
      end

      `uvm_info(`gfn, "item sent", UVM_HIGH)
      seq_item_port.item_done(rsp);
    end
  endtask

endclass
