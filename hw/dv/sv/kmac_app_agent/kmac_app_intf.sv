// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// verilog_lint: waive interface-name-style
interface kmac_app_intf (input clk, input rst_n);

  import keymgr_pkg::*;

  dv_utils_pkg::if_mode_e if_mode; // interface mode - Host or Device

  // interface pins used to connect with DUT
  wire kmac_pkg::app_req_t kmac_data_req;
  wire kmac_pkg::app_rsp_t kmac_data_rsp;

  // interface pins used in driver/monitor
  push_pull_if #(.HostDataWidth(kmac_app_agent_pkg::KMAC_REQ_DATA_WIDTH))
      req_data_if(.clk(clk), .rst_n(rst_n));
  // Response channel: push_pull_if in Device mode when kmac_app is Host (TB drives ready),
  // or in Host mode when kmac_app is Device.  h_data packs
  // {rsp_digest_share0, rsp_digest_share1, rsp_error, rsp_finish}.
  push_pull_if #(.HostDataWidth(kmac_app_agent_pkg::KMAC_RSP_DATA_WIDTH))
      rsp_data_if(.clk(clk), .rst_n(rst_n));
  wire rsp_valid;
  wire [kmac_pkg::AppDigestW-1:0] rsp_digest_share0;
  wire [kmac_pkg::AppDigestW-1:0] rsp_digest_share1;
  wire rsp_error;
  wire rsp_finish;

  clocking mon_cb @(posedge clk);
    input rst_n;
    input rsp_valid;
    input rsp_digest_share0;
    input rsp_digest_share1;
    input rsp_error;
    input rsp_finish;
    input rsp_ready = rsp_data_if.ready;
  endclocking

  always @(if_mode) req_data_if.if_mode = if_mode;

  // Host mode: feed DUT response signals into rsp_data_if so the push_pull monitor sees
  // valid/ready handshakes.  The push_pull device driver drives rsp_data_if.ready.
  assign rsp_data_if.valid  = (if_mode == dv_utils_pkg::Host) ? rsp_valid : 'z;
  assign rsp_data_if.h_data = (if_mode == dv_utils_pkg::Host) ?
      {rsp_digest_share0, rsp_digest_share1, rsp_error, rsp_finish} : 'z;

  // Device mode: push_pull host driver drives rsp_data_if.valid/h_data; the app DUT's
  // rsp_ready feeds back as rsp_data_if.ready so the push_pull monitor sees the handshake.
  assign rsp_data_if.ready          = (if_mode == dv_utils_pkg::Device) ?
      kmac_data_req.rsp_ready : 'z;
  assign rsp_valid                  = (if_mode == dv_utils_pkg::Device) ?
      rsp_data_if.valid : 'z;
  assign {rsp_digest_share0, rsp_digest_share1, rsp_error, rsp_finish} =
      (if_mode == dv_utils_pkg::Device) ? rsp_data_if.h_data : 'z;

  // Explicitly pack struct fields to handle the two-share req format. data_s1 is
  // not driven by the push_pull_if (single-share / unmasked operations only).
  assign kmac_data_req = (if_mode == dv_utils_pkg::Host) ?
      {req_data_if.valid,
       req_data_if.h_data[KmacDataIfWidth + KmacDataIfWidth/8 : KmacDataIfWidth/8 + 1],
       {KmacDataIfWidth{1'b0}},
       req_data_if.h_data[KmacDataIfWidth/8 : 1],
       req_data_if.h_data[0],
       rsp_data_if.ready}
      : 'z;
  assign {req_data_if.valid, req_data_if.h_data} = (if_mode == dv_utils_pkg::Device) ?
      {kmac_data_req.req_valid,
       kmac_data_req.data_s0,
       kmac_data_req.strb,
       kmac_data_req.req_last}
      : 'z;

  assign {req_data_if.ready, rsp_valid, rsp_digest_share0, rsp_digest_share1, rsp_error,
          rsp_finish} =
         (if_mode == dv_utils_pkg::Host) ? kmac_data_rsp : 'z;
  assign kmac_data_rsp = (if_mode == dv_utils_pkg::Device) ?
         {req_data_if.ready, rsp_valid, rsp_digest_share0, rsp_digest_share1, rsp_error,
          rsp_finish} : 'z;

  // The following assertions only apply to device mode.
  // strb should never be 0
  `ASSERT(StrbNotZero_A, kmac_data_req.req_valid |-> kmac_data_req.strb > 0,
          clk, !rst_n || if_mode == dv_utils_pkg::Host)

  // Check strb is aligned to LSB, for example: if strb[1]==0, strb[$:2] should be 0 too
  for (genvar k = 1; k < KmacDataIfWidth / 8 - 1; k++) begin : gen_strb_check
    `ASSERT(StrbAlignLSB_A, kmac_data_req.req_valid && kmac_data_req.strb[k] === 0 |->
                            kmac_data_req.strb[k+1] === 0,
                            clk, !rst_n || if_mode == dv_utils_pkg::Host)
  end

  // The following assertions apply for this interface for all modes.

  // Done should be asserted after last, before we start another request
  `ASSERT(DoneAssertAfterLast_A,
    (kmac_data_req.req_last && kmac_data_req.req_valid && kmac_data_rsp.req_ready) |=>
    !kmac_data_req.req_valid throughout rsp_valid[->1], clk, !rst_n || rsp_error)

endinterface
