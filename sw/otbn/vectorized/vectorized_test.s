/* Copyright lowRISC contributors (OpenTitan project). */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */

/*
 * A simple test for all vectorized instructions callable from Ibex to test the ISA extension
 * on the full system. It executes all instructions on given input vectors.
 */

/**
 * Externally callable program for the vectorized test.
 * Executes each instruction at least once. For the Montgomery multiplication instructions the
 * extra required bn.addv with a zero vector is performed, so the result is correct Montgomery
 * computation.
 * Returns the computation results at the specified locations in DMEM.
 *
 * The parameters are expected in DMEM in increasing order. Each parameter is 256b wide.
 * @param[in]  dmem[31:0]: mod32;     The modulus value for bn.addvm and bn.subvm. Only the lower
 *                                    32bits are of interest.
 * @param[in]  dmem[.]: vec_a_addv;   1st vector for bn.addv
 * @param[in]  dmem[.]: vec_b_addv;   2nd vector for bn.addv
 * @param[out] dmem[.]: res_addv;     Result of bn.addv
 * @param[in]  dmem[.]: vec_a_addvm;  1st vector for bn.addvm
 * @param[in]  dmem[.]: vec_b_addvm;  2nd vector for bn.addvm
 * @param[out] dmem[.]: res_addvm;    Result of bn.addvm
 * @param[in]  dmem[.]: vec_a_subv;   1st vector for bn.subv
 * @param[in]  dmem[.]: vec_b_subv;   2nd vector for bn.subv
 * @param[out] dmem[.]: res_subv;     Result of bn.subv
 * @param[in]  dmem[.]: vec_a_subvm;  1st vector for bn.subvm
 * @param[in]  dmem[.]: vec_b_subvm;  2nd vector for bn.subvm
 * @param[out] dmem[.]: res_subvm;    Result of bn.subvm
 * @param[in]  dmem[.]: vec_a_shv;    1st vector for bn.shv
 * @param[in]  dmem[.]: vec_b_shv;    2nd vector for bn.shv
 * @param[out] dmem[.]: res_shv_1;    1st result of bn.shv
 * @param[out] dmem[.]: res_shv_2;    2nd result of bn.shv
 * @param[in]  dmem[.]: vec_a_trn;    1st vector for bn.trn1/2
 * @param[in]  dmem[.]: vec_b_trn;    2nd vector for bn.trn1/2
 * @param[out] dmem[.]: res_trn1_32;  Result of bn.trn1 for 32b elements
 * @param[out] dmem[.]: res_trn1_64;  Result of bn.trn1 for 64b elements
 * @param[out] dmem[.]: res_trn1_128; Result of bn.trn1 for 128b elements
 * @param[out] dmem[.]: res_trn2_32;  Result of bn.trn2 for 32b elements
 * @param[out] dmem[.]: res_trn2_64;  Result of bn.trn2 for 64b elements
 * @param[out] dmem[.]: res_trn2_128; Result of bn.trn2 for 128b elements
 * @param[in]  dmem[.]: vec_a_mulv;   1st vector for bn.mulv(l)
 * @param[in]  dmem[.]: vec_b_mulv;   2nd vector for bn.mulv(l)
 * @param[out] dmem[.]: res_mulv;     Result of bn.mulv
 * @param[out] dmem[.]: res_mulvl;    Result of bn.mulvl
 * @param[in]  dmem[.]: mod32_montg;  The modulus (q) and Montgomery constant (R) for bn.mulvm(l)
                                      Expected format: q @ [31:0], R @ [63:32]
 * @param[in]  dmem[.]: vec_a_mulvm;  1st vector for bn.mulvm(l)
 * @param[in]  dmem[.]: vec_b_mulvm;  2nd vector for bn.mulvm(l)
 * @param[out] dmem[.]: res_mulvm;    Result of bn.mulvm
 * @param[out] dmem[.]: res_mulvml;   Result of bn.mulvml
 */
.section .text.start
.globl vectorized_test
vectorized_test:
  /* Initialize all-zero register. */
  bn.xor w31, w31, w31

  /* Load modulus */
  li      x2,  0
  la      x3,  mod32
  bn.lid  x2,  0(x3)
  bn.wsrw MOD, w0

  /* BN.ADDV */
  li         x2,   0
  la         x3,   vec_a_addv
  bn.lid     x2++, 0(x3)
  bn.lid     x2++, 32(x3)
  bn.addv.8S w2,   w0, w1
  bn.sid     x2,   64(x3)

  /* BN.ADDVM */
  li          x2,   0
  la          x3,   vec_a_addvm
  bn.lid      x2++, 0(x3)
  bn.lid      x2++, 32(x3)
  bn.addvm.8S w2,   w0, w1
  bn.sid      x2,   64(x3)

  /* BN.SUBV */
  li         x2,   0
  la         x3,   vec_a_subv
  bn.lid     x2++, 0(x3)
  bn.lid     x2++, 32(x3)
  bn.subv.8S w2,   w0, w1
  bn.sid     x2,   64(x3)

  /* BN.SUBVM */
  li          x2,   0
  la          x3,   vec_a_subvm
  bn.lid      x2++, 0(x3)
  bn.lid      x2++, 32(x3)
  bn.subvm.8S w2,   w0, w1
  bn.sid      x2,   64(x3)

  /* BN.SHV */
  li        x2,   0
  la        x3,   vec_shv
  bn.lid    x2++, 0(x3)
  bn.shv.8S w1,   w0 >> 11
  bn.sid    x2++, 32(x3)
  bn.shv.8S w2,   w0 << 22
  bn.sid    x2,   64(x3)

  /* BN.TRN1 & BN.TRN2 */
  li         x2,   0
  la         x3,   vec_a_trn
  bn.lid     x2++, 0(x3)
  bn.lid     x2++, 32(x3)
  bn.trn1.8S w2,   w0, w1
  bn.trn1.4D w3,   w0, w1
  bn.trn1.2Q w4,   w0, w1
  bn.sid     x2++, 64(x3)
  bn.sid     x2++, 96(x3)
  bn.sid     x2++, 128(x3)
  bn.trn2.8S w5,   w0, w1
  bn.trn2.4D w6,   w0, w1
  bn.trn2.2Q w7,   w0, w1
  bn.sid     x2++, 160(x3)
  bn.sid     x2++, 192(x3)
  bn.sid     x2++, 224(x3)

  /* BN.MULV & BN.MULVL */
  li          x2,   0
  la          x3,   vec_a_mulv
  bn.lid      x2++, 0(x3)
  bn.lid      x2++, 32(x3)
  bn.mulv.8S  w2,   w0, w1
  bn.mulvl.8S w3,   w0, w1, 5
  bn.sid      x2++, 64(x3)
  bn.sid      x2++, 96(x3)

  /* BN.MULVM & BN.MULVML */
  /* Load modulus and Montgomery constant */
  li      x2,  0
  la      x3,  mod32_montg
  bn.lid  x2,  0(x3)
  bn.wsrw MOD, w0

  li           x2,   0
  la           x3,   vec_a_mulvm
  bn.lid       x2++, 0(x3)
  bn.lid       x2++, 32(x3)
  bn.mulvm.8S  w2,   w0, w1
  bn.mulvml.8S w3,   w0, w1, 5
  bn.sid       x2++, 64(x3)
  bn.sid       x2++, 96(x3)

  /* BN.PACK */
  li      x2,   0
  la      x3,   vec_pack
  bn.lid  x2++, 0(x3)
  bn.xor  w1,   w1, w1
  bn.pack w1,   w1, w0, 64
  bn.sid  x2,   32(x3)

  /* BN.UNPK */
  li      x2,   0
  la      x3,   vec_unpk
  bn.lid  x2++, 0(x3)
  bn.xor  w1,   w1, w1
  bn.unpk w1,   w1, w0, 0
  bn.sid  x2,   32(x3)

  ecall


.data
/*****************
 * Modulus value *
 *****************/
.globl mod32
.balign 32
mod32:
  .zero 32

/***********
/* BN.ADDV *
 ***********/
.globl vec_a_addv
.balign 32
vec_a_addv:
  .zero 32

.globl vec_b_addv
.balign 32
vec_b_addv:
  .zero 32

.globl res_addv
.balign 32
res_addv:
  .zero 32

/************
/* BN.ADDVM *
 ************/
.globl vec_a_addvm
.balign 32
vec_a_addvm:
  .zero 32

.globl vec_b_addvm
.balign 32
vec_b_addvm:
  .zero 32

.globl res_addvm
.balign 32
res_addvm:
  .zero 32

/***********
 * BN.SUBV *
 ***********/
.globl vec_a_subv
.balign 32
vec_a_subv:
  .zero 32

.globl vec_b_subv
.balign 32
vec_b_subv:
  .zero 32

.globl res_subv
.balign 32
res_subv:
  .zero 32

/************
 * BN.SUBVM *
 ************/
.globl vec_a_subvm
.balign 32
vec_a_subvm:
  .zero 32

.globl vec_b_subvm
.balign 32
vec_b_subvm:
  .zero 32

.globl res_subvm
.balign 32
res_subvm:
  .zero 32

/**********
 * BN.SHV *
 **********/
.globl vec_shv
.balign 32
vec_shv:
  .zero 32

.globl res_shv_1
.balign 32
res_shv_1:
  .zero 32

/* 2nd result for two shift values */
.globl res_shv_2
.balign 32
res_shv_2:
  .zero 32

/*************
 * BN.TRN1/2 *
 *************/
.globl vec_a_trn
.balign 32
vec_a_trn:
  .zero 32

.globl vec_b_trn
.balign 32
vec_b_trn:
  .zero 32

.globl res_trn1_32
.balign 32
res_trn1_32:
  .zero 32

.globl res_trn1_64
.balign 32
res_trn1_64:
  .zero 32

.globl res_trn1_128
.balign 32
res_trn1_128:
  .zero 32

.globl res_trn2_32
.balign 32
res_trn2_32:
  .zero 32

.globl res_trn2_64
.balign 32
res_trn2_64:
  .zero 32

.globl res_trn2_128
.balign 32
res_trn2_128:
  .zero 32

/**********************
 * BN.MULV & BN.MULVL *
 **********************/
.globl vec_a_mulv
.balign 32
vec_a_mulv:
  .zero 32

.globl vec_b_mulv
.balign 32
vec_b_mulv:
  .zero 32

.globl res_mulv
.balign 32
res_mulv:
  .zero 32

.globl res_mulvl
.balign 32
res_mulvl:
  .zero 32

/*********************************
 * Modulus + Montgomery constant *
 *********************************/
/* complete WSR for MOD with the modulus (q) and the Montgomery constant (R) at the following bits:
 * `q @ MOD[31:0]`, `R @ MOD[63:32]`
 */
.globl mod32_montg
.balign 32
mod32_montg:
  .zero 32

/************************
 * BN.MULVM & BN.MULVML *
 ************************/
.globl vec_a_mulvm
.balign 32
vec_a_mulvm:
  .zero 32

.globl vec_b_mulvm
.balign 32
vec_b_mulvm:
  .zero 32

.globl res_mulvm
.balign 32
res_mulvm:
  .zero 32

.globl res_mulvml
.balign 32
res_mulvml:
  .zero 32

/***********
 * BN.PACK *
 ***********/
.globl vec_pack
.balign 32
vec_pack:
  .zero 32

.globl res_pack
.balign 32
res_pack:
  .zero 32

/***********
 * BN.UNPK *
 ***********/
.globl vec_unpk
.balign 32
vec_unpk:
  .zero 32

.globl res_unpk
.balign 32
res_unpk:
  .zero 32
