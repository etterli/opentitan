/* Copyright lowRISC contributors (OpenTitan project). */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */

.section .text.start
/********************************
 * BN.SHV - Only each ELEN once *
 ********************************/
addi x2, x0, 0

la     x3, vecorig_bnshv
bn.lid x2, 0(x3)

bn.shv.8S  w3, w0 << 11
bn.shv.8S  w4, w0 >> 30

ecall

.section .data
/*
  vector for instruction shv
  vecorig = 0x9397271b502c41d6cf2538cfa72bf6800d250f06252fff02a626711a3a60e2eb
*/
vecorig_bnshv:
  .word 0x3a60e2eb
  .word 0xa626711a
  .word 0x252fff02
  .word 0x0d250f06
  .word 0xa72bf680
  .word 0xcf2538cf
  .word 0x502c41d6
  .word 0x9397271b

/*
  Result of 32bit shv left (res = [bitshift in decimals])
  res = [11]
  res = 0xb938d800620eb00029c678005fb40000287830007ff810003388d00007175800
*/
/*
  Result of 32bit shv right (res = [bitshift in decimals])
  res = [30]
  res = 0x0000000200000001000000030000000200000000000000000000000200000000
*/
