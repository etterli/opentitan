/* Copyright lowRISC contributors (OpenTitan project). */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */

.section .text.start
addi   x2,   x0, 2
la     x3,   vec32a0
bn.lid x2++, 0(x3)
la     x3,   vec32b0
bn.lid x2++, 0(x3)

/* Load the modulus into w20 and then into MOD */
/* MOD <= dmem[modulus] = p */
li           x2,  20
la           x3,  mod32
bn.lid       x2,  0(x3)
bn.wsrw      MOD, w20

bn.mulvml.8S w11, w2, w3, 2

ecall

.section .data
/*
  NOTE!
  The result are nonsense because both inputs are in the Montgomery space.
  If one input would be in original space the result would make sense.
  However, the RTL only implements a montgomery multiplication and no extra
  reduction afterwards. Nonetheless, the implementation can be tested this way.
*/

/*
  32bit vector mod32 for instruction mulvml. Combined [R, q]
  mod32 = [4236238847, 8380417]
  mod32 = 0x000000000000000000000000000000000000000000000000fc7fdfff007fe001
*/
mod32:
  .word 0x007fe001
  .word 0xfc7fdfff
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000

/*
  32bit vector vec32a0 for instruction mulvml
  vec32a0 = [140140, 2179652, 4415585, 3591344, 6089560, 5367875, 2289882, 4817594]
  vec32a0 = 0x0002236c00214244004360610036ccb0005ceb580051e8430022f0da004982ba
*/
vec32a0:
  .word 0x004982ba
  .word 0x0022f0da
  .word 0x0051e843
  .word 0x005ceb58
  .word 0x0036ccb0
  .word 0x00436061
  .word 0x00214244
  .word 0x0002236c

/*
  32bit vector vec32b0 for instruction mulvml
  vec32b0 = [7268407, 3661137, 7621524, 6778366, 6274350, 2059156, 3886783, 2027657]
  vec32b0 = 0x006ee8370037dd5100744b9400676dfe005fbd2e001f6b94003b4ebf001ef089
*/
vec32b0:
  .word 0x001ef089
  .word 0x003b4ebf
  .word 0x001f6b94
  .word 0x005fbd2e
  .word 0x00676dfe
  .word 0x00744b94
  .word 0x0037dd51
  .word 0x006ee837

/*
  Result of 32bit mulvml
  res = [3799922, 2633898, 6995632, 4805232, 5548368, 8169851, 4166069, 6325177]
  res = 0x0039fb72002830aa006abeb0004952700054a950007ca97b003f91b5006083b9
*/
