// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`include "prim_assert.sv"

/**
 * Vectorized Multiplier
 *
 * This module implements a vectorized multiplier which can compute either one 64-bit or two 32-bit
 * multiplications. The input operands are interpreted as vectors with either one or two elements,
 * respectively. The multiplication is split into its 32-bit partial products and finally shifted
 * and summed accordingly ("schoolbook" algorithm). Consider the following operand splitting:
 *
 * Operand a: [a1, a0], where a is split into two 32-bit chunks
 * Operand b: [b1, b0], where b is split into two 32-bit chunks
 * Radix: R = 2^Radix (= 2^32)
 *
 * The result for the 64-bit multiplication a * b can then be split using
 * a = a0 + R*a1
 *
 * into
 *
 * a * b = a0*b0 + R * (a0*b1 + a1*b0) + R^2 * (a1*b1)
 *
 * To compute vectorized 32-bit multiplications a subset of the partial products can
 * directly be used, i.e.:
 * c0 = a0 * b0
 * c1 = a1 * b1
 *
 * The 32-bit results c0, c1 can be reused for the 64-bit multiplication. Rearrange the
 * original a*b to:
 * a * b =         c0
 *         + R   * (a0*b1 + a1*b0)
 *         + R^2 * c1
 */
module otbn_vec_multiplier
  import otbn_pkg::*;
#(
  localparam int Width      = 64, // Must be power of 2
  localparam int RadixPower = 32, // Must be power of 2
  localparam int NumChunks = Width / RadixPower
) (
    input  logic [Width-1:0]   operand_a_i,
    input  logic [Width-1:0]   operand_b_i,
    input  mac_elen_e          elen_i,
    output logic [2*Width-1:0] result_o
);

  logic [NumChunks-1:0][RadixPower-1:0] op_a_chunks, op_b_chunks;
  assign op_a_chunks = operand_a_i;
  assign op_b_chunks = operand_b_i;

  ////////////////////////////////
  // Partial product generation //
  ////////////////////////////////
  // The first unpacked dimension indexes operand a, the 2nd operand b
  logic [(2*RadixPower)-1:0] part_prods [NumChunks][NumChunks];

  // For 64b we need all partial products.
  // For 32b we only need two partial products.
  // Partial products used in all cases: a0*b0, a1*b1
  assign part_prods[0][0] = op_a_chunks[0] * op_b_chunks[0];
  assign part_prods[1][1] = op_a_chunks[1] * op_b_chunks[1];

  // Partial products used only for 64b: a0*b1, a1*b0
  // These are zeroed if unused to simplify partial product summation
  assign part_prods[0][1] = (elen_i == MacElen64) ? op_a_chunks[0] * op_b_chunks[1] : '0;
  assign part_prods[1][0] = (elen_i == MacElen64) ? op_a_chunks[1] * op_b_chunks[0] : '0;

  ///////////////////////////////
  // Partial product summation //
  ///////////////////////////////
  // Compute the results by summing the partial products (PP) depending on ELEN.
  // - In the 32b case there is no summation required, just output the two partial products.
  // - In the 64b case sum up the four partial products each.
  //
  // The 64b summation is given below. To consider the weight of the PPs, the PPs must be shifted
  // accordingly which is indicated by the zeros.
  //
  //             [a0 * b0]
  //  +     [a1 * b0]0000    // PP is '0 for 32b case
  //  +     [a0 * b1]0000    // PP is '0 for 32b case
  //  + [a1 * b1]00000000    // No overlap with a0*b0 partial product
  // ---------------------
  //         64b result
  //
  // For the 32b case, the result is simply the concatenation of the lower and upper PP.
  // Instead of MUX-ing between the two results, we can use the 64b summation result as well
  // because the middle PPs are set to all-zero.
  assign result_o =
      (2*Width)'(part_prods[0][0]) +
    (((2*Width)'(part_prods[0][1]) + (2*Width)'(part_prods[1][0])) << RadixPower) +
    (((2*Width)'(part_prods[1][1])) << 2*RadixPower);

endmodule
