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
    cfg.sw_logger_vif.wait_for_log_message("KeymgrDpe derived DPE context with the OTBN (HKDF)");

    // At this point, exactly one key slot should contain a key. This key must be the child of the
    // CreatorRootKey, i.e., it has advanced to boot stage 2. Verify that this holds.
    begin
      bit key_found = 1'b0;
      key_slot_idx = 0;
      for (int i = 0; i < num_hw_slots; i++) begin
        keymgr_dpe_pkg::keymgr_dpe_slot_t slot = get_key_slot(i);
        if (slot.valid) begin
          `DV_CHECK_EQ(key_found, 1'b0, "Expecting only one key")
          `DV_CHECK_EQ(slot.boot_stage, keymgr_dpe_pkg::BootStageOwnerInt,
                       "Expecting the derived key to be in boot stage 2")
          key_found = 1'b1;
          key = slot.key;
          key_slot_idx = i;
        end
      end
      `DV_CHECK_EQ(key_found, 1'b1, "Expecting one valid key slot")
    end

    // The derived key must differ from its parent
    `DV_CHECK_NE(get_unmasked_key(key), get_unmasked_key(creator_key),
                 "Expecting the derived key to differ from the CreatorRootKey")

    // Print the generated key
    `uvm_info(`gfn, $sformatf("Derived key in slot %0d:\n%s", key_slot_idx,
        key_shares_str(key)), UVM_LOW)

  endtask

endclass : chip_sw_keymgr_dpe_otbn_hkdf_vseq
