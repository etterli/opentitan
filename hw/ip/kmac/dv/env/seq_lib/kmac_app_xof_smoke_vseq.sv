// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Smoke test for the AppDynamic interface.
//
// Sends a randomized message and verifies the digest against the DPI reference model.
class kmac_app_xof_smoke_vseq extends kmac_sideload_vseq;
  `uvm_object_utils(kmac_app_xof_smoke_vseq)
  `uvm_object_new

  // which app interface to test. For now fixed to OTBN app interface.
  // TODO: constrain this to all apps which have type dynamic (via APP_CFG?)
  localparam kmac_app_e dut_app = AppOtbn;

  constraint msg_c {
    msg.size() inside {[1:1000]};
  }

  // AppDynamic mode and strength encoded in the config beat.
  rand kmac_pkg::app_mode_e        dyn_mode;
  rand sha3_pkg::keccak_strength_e dyn_strength;

  // Number of 64-bit digest chunks the host will request.
  rand int unsigned output_chunks;

  // Valid mode/strength combinations under test.
  constraint dyn_mode_strength_c {
    dyn_mode inside {kmac_pkg::AppShake, kmac_pkg::AppSHA3};
    if (dyn_mode == kmac_pkg::AppShake) {
      dyn_strength inside {sha3_pkg::L128, sha3_pkg::L256};
    } else {
      dyn_strength inside {sha3_pkg::L256, sha3_pkg::L512};
    }
  }

  // SHAKE: random length covering single-squeeze and multi-squeeze.
  // SHA3-256: 4 chunks = full output (sha3-256); 2 chunks = 128 bits
  constraint output_chunks_c {
    if (dyn_mode == kmac_pkg::AppShake) {
      output_chunks inside {[1:32]};
    } else {
      if (dyn_strength == sha3_pkg::L256) {
        output_chunks == 4;
      } else {
        output_chunks == 8; // 512 / 64 = 8
      }
    }
  }

  // AppDynamic does not use the KMAC keyed-hash mode.
  // TODO: it does support it.
  constraint kmac_en_c { kmac_en == 0; }

  virtual task pre_start();
    // TODO: remove this once KMAC is supported
    en_sideload_c.constraint_mode(0);
    cfg.m_kmac_app_agent_cfg[dut_app].app_type       = AppDynamic; // TODO: assert this?
    cfg.m_kmac_app_agent_cfg[dut_app].app_mode       = dyn_mode;
    cfg.m_kmac_app_agent_cfg[dut_app].app_strength   = dyn_strength;
    cfg.m_kmac_app_agent_cfg[dut_app].req_output_len = output_chunks;
    `uvm_info(get_type_name(),
          $sformatf("KMAC app config: app_type=%s app_mode=%s app_strength=%s req_output_len=%0d",
              cfg.m_kmac_app_agent_cfg[dut_app].app_type.name(),
              dyn_mode.name(),
              dyn_strength.name(),
              cfg.m_kmac_app_agent_cfg[dut_app].req_output_len),
          UVM_LOW)
    super.pre_start();
  endtask

  virtual task body();
    kmac_app_xof_host_seq xof_seq;

    kmac_init();
    // We must provide a seed for the entropy module via SW.
    if (cfg.enable_masking && entropy_mode == EntropyModeSw) begin
      `uvm_info(`gfn, "providing SW entropy", UVM_HIGH)
      provide_sw_entropy();
    end

    `uvm_create_on(xof_seq, p_sequencer.kmac_app_sequencer_h[dut_app])
    foreach (msg[i]) xof_seq.msg_q.push_back(msg[i]);
    xof_seq.req_output_len = output_chunks;
    `uvm_send(xof_seq)

    cfg.clk_rst_vif.wait_clks(100);
  endtask

endclass
