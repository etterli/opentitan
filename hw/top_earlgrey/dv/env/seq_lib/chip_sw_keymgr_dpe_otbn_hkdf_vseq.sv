// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class chip_sw_keymgr_dpe_otbn_hkdf_vseq extends chip_sw_keymgr_dpe_key_derivation_vseq;
  `uvm_object_utils(chip_sw_keymgr_dpe_otbn_hkdf_vseq)

  `uvm_object_new

  virtual task run_test_sequence(key_shares_t creator_key);
    key_shares_t key;
    int key_slot_idx;

    // Wait for keymgr_dpe to generate a DPE context with the OTBN
    `DV_WAIT(cfg.sw_logger_vif.printed_log == "KeymgrDpe derived DPE context with the OTBN (HKDF)")

    // At this point, exactly one key slot should contain a key. Verify that this holds.
    begin
      bit key_found = 1'b0;
      key_slot_idx = 0;
      for (int i = 0; i < num_hw_slots; i++) begin
        keymgr_dpe_pkg::keymgr_dpe_slot_t slot = get_key_slot(i);
        if (slot.valid) begin
          `DV_CHECK_EQ(key_found, 1'b0, "Expecting only one key")
          key_found = 1'b1;
          key = slot.key;
          key_slot_idx = i;
        end
      end
    end

    // Print the generated key
    `uvm_info(`gfn, $sformatf("Derived key in slot %0d:\n%s", key_slot_idx,
        key_shares_str(key)), UVM_LOW)

  endtask

endclass : chip_sw_keymgr_dpe_otbn_hkdf_vseq
