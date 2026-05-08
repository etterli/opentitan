// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class kmac_app_item extends uvm_sequence_item;

  // random variables

  // request data/mask
  //
  // also used by the monitor to assemble the full request message
  rand byte byte_data_q[$];

  // App interface type determines digest collection mode.
  kmac_pkg::app_type_e app_type = kmac_pkg::AppStatic;

  // For AppDynamic: how many digest parts the host will request.
  int unsigned req_output_len = 0;

  // Static mode: single full-width digest (384 bits each share).
  rand bit [kmac_pkg::AppDigestW-1:0] digest_s0;
  rand bit [kmac_pkg::AppDigestW-1:0] digest_s1;

  // Dynamic mode: stream of 64-bit digest chunks.
  bit [kmac_pkg::DynAppDigestW-1:0] digest_chunks_s0[$];
  bit [kmac_pkg::DynAppDigestW-1:0] digest_chunks_s1[$];

  rand bit error;

  rand int unsigned rsp_delay;

  `uvm_object_utils_begin(kmac_app_item)
    `uvm_field_queue_int(byte_data_q,      UVM_DEFAULT)
    `uvm_field_enum(kmac_pkg::app_type_e, app_type, UVM_DEFAULT)
    `uvm_field_int(req_output_len,         UVM_DEFAULT)
    `uvm_field_int(digest_s0,              UVM_DEFAULT)
    `uvm_field_int(digest_s1,              UVM_DEFAULT)
    `uvm_field_queue_int(digest_chunks_s0, UVM_DEFAULT)
    `uvm_field_queue_int(digest_chunks_s1, UVM_DEFAULT)
    `uvm_field_int(error,                  UVM_DEFAULT)
    `uvm_field_int(rsp_delay,              UVM_DEFAULT)
  `uvm_object_utils_end

  `uvm_object_new

  virtual function bit get_is_kmac_rsp_data_invalid();
    return is_constant_share(digest_s0) || is_constant_share(digest_s1);
  endfunction

  static function bit is_constant_share(bit [kmac_pkg::AppDigestW-1:0] share);
    return share inside {'0, '1};
  endfunction

endclass
