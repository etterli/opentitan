// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "hw/top/dt/dt_otbn.h"
#include "sw/device/lib/dif/dif_otbn.h"
#include "sw/device/lib/runtime/ibex.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/entropy_testutils.h"
#include "sw/device/lib/testing/otbn_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"

/****************
 * Test vectors *
 ****************/

/**
 * We turn off the formating checks to enable us to list 256b values and their
 *  vector representations as one string.
 * */
// clang-format off

/*
  32bit vector mod32
  mod32 = [8380417]
  mod32 = 0x00000000000000000000000000000000000000000000000000000000007fe001
*/
static const uint32_t mod32[] = {
  8380417, 0, 0, 0, 0, 0, 0, 0
};
/*
  32bit vector mod32 for instruction mulvm(l). Combined [R, q]
  mod32 = [4236238847, 8380417]
  mod32 = 0x000000000000000000000000000000000000000000000000fc7fdfff007fe001
*/
static const uint32_t mod32_montg[] = {
  0x007fe001, 0xfc7fdfff, 0, 0, 0, 0, 0, 0
};

/***********
 * BN.ADDV *
 ***********/
/*
  32bit vector a for instruction addv
  vec32a0 = [4294967295, 4294967295, 2147483647, 0, 5630, 4294967295, 1684, 0]
  vec32a0 = 0xffffffffffffffff7fffffff00000000000015feffffffff0000069400000000
             MSB                                                            LSB
*/
static const uint32_t vec_a_addv[] = {
  0, 1684, 4294967295, 5630, 0, 2147483647, 4294967295, 4294967295
};
/*
  32bit vector b for instruction addv
  vec32b0 = [2024, 1, 2147483647, 2147483647, 123, 1, 437, 4294967295]
  vec32b0 = 0x000007e8000000017fffffff7fffffff0000007b00000001000001b5ffffffff
*/
static const uint32_t vec_b_addv[] = {
  4294967295, 437, 1, 123, 2147483647, 2147483647, 1, 2024
};
/*
  Result of 32bit addv
  res = [2023, 0, 4294967294, 2147483647, 5753, 0, 2121, 4294967295]
  res = 0x000007e700000000fffffffe7fffffff000016790000000000000849ffffffff
*/
static const uint32_t exp_addv[] = {
  4294967295, 2121, 0, 5753, 2147483647, 4294967294, 0, 2023
};
// Buffer to read back from OTBN
static uint32_t res_addv[8];

/************
 * BN.ADDVM *
 ************/
/*
  32bit vector a for instruction addvm
  vec32a0 = [4294967295, 4294967295, 4190208, 8380416, 4294967295, 0, 4190208, 8380416]
  vec32a0 = 0xffffffffffffffff003ff000007fe000ffffffff00000000003ff000007fe000
*/
static const uint32_t vec_a_addvm[] = {
  8380416, 4190208, 0, 4294967295, 8380416, 4190208, 4294967295, 4294967295
};
/*
  32bit vector b for instruction addvm
  vec32b0 = [2024, 1, 2793472, 8380414, 2024, 2147483647, 2793472, 8380414]
  vec32b0 = 0x000007e800000001002aa000007fdffe000007e87fffffff002aa000007fdffe
*/
static const uint32_t vec_b_addvm[] = {
  8380414, 2793472, 2147483647, 2024, 8380414, 2793472, 1, 2024
};
/*
  Result of 32bit addvm
  res = [4286588902, 4286586879, 6983680, 8380413, 4286588902, 2139103230, 6983680, 8380413]
  res = 0xff8027e6ff801fff006a9000007fdffdff8027e67f801ffe006a9000007fdffd
*/
static const uint32_t exp_addvm[] = {
  8380413, 6983680, 2139103230, 4286588902, 8380413, 6983680, 4286586879, 4286588902
};
// Buffer to read back from OTBN
static uint32_t res_addvm [8];

/***********
 * BN.SUBV *
 ***********/
/*
  32bit vector a for instruction subv
  vec32a0 = [0, 0, 2147483647, 2147483647, 0, 4294967295, 1684, 0]
  vec32a0 = 0x00000000000000007fffffff7fffffff00000000ffffffff0000069400000000
*/
static const uint32_t vec_a_subv[] = {
  0, 1684, 4294967295, 0, 2147483647, 2147483647, 0, 0
};
/*
  32bit vector b for instruction subv
  vec32b0 = [2048, 1, 2147483647, 0, 2048, 1, 437, 1]
  vec32b0 = 0x00000800000000017fffffff000000000000080000000001000001b500000001
*/
static const uint32_t vec_b_subv[] = {
  1, 437, 1, 2048, 0, 2147483647, 1, 2048
};
/*
  Result of 32bit subv
  res = [4294965248, 4294967295, 0, 2147483647, 4294965248, 4294967294, 1247, 4294967295]
  res = 0xfffff800ffffffff000000007ffffffffffff800fffffffe000004dfffffffff
*/
static const uint32_t exp_subv[] = {
  4294967295, 1247, 4294967294, 4294965248, 2147483647, 0, 4294967295, 4294965248
};
// Buffer to read back from OTBN
static uint32_t res_subv [8];

/************
 * BN.SUBVM *
 ************/
/*
  32bit vector a for instruction subvm
  vec32a0 = [0, 0, 4190208, 8380414, 0, 4294967295, 4190208, 8380414]
  vec32a0 = 0x0000000000000000003ff000007fdffe00000000ffffffff003ff000007fdffe
*/
static const uint32_t vec_a_subvm[] = {
  8380414, 4190208, 4294967295, 0, 8380414, 4190208, 0, 0
};
/*
  32bit vector b for instruction subvm
  vec32b0 = [2048, 1, 2793472, 8380416, 2048, 2147483647, 2793472, 8380416]
  vec32b0 = 0x0000080000000001002aa000007fe000000008007fffffff002aa000007fe000
*/
static const uint32_t vec_b_subvm[] = {
  8380416, 2793472, 2147483647, 2048, 8380416, 2793472, 1, 2048
};
/*
  Result of 32bit subvm
  res = [8378369, 8380416, 1396736, 8380415, 8378369, 2147483648, 1396736, 8380415]
  res = 0x007fd801007fe00000155000007fdfff007fd8018000000000155000007fdfff
*/
static const uint32_t exp_subvm[] = {
  8380415, 1396736, 2147483648, 8378369, 8380415, 1396736, 8380416, 8378369
};
// Buffer to read back from OTBN
static uint32_t res_subvm [8];

/**********
 * BN.SHV *
 **********/
/*
  32bit vector vec32orig for instruction shv
  vec32orig = 0x9397271b502c41d6cf2538cfa72bf6800d250f06252fff02a626711a3a60e2eb
               MSB                                                            LSB
*/
static const uint32_t vec_shv[] = {
  0x3a60e2eb, 0xa626711a, 0x252fff02, 0x0d250f06,
  0xa72bf680, 0xcf2538cf, 0x502c41d6, 0x9397271b
};
/*
  Result of 32bit shv right (res = [bitshift in decimals])
  res = [11]
  res = 0x001272e4000a05880019e4a70014e57e0001a4a10004a5ff0014c4ce00074c1c
*/
static const uint32_t exp_shv_1[] = {
  0x00074c1c, 0x0014c4ce, 0x0004a5ff, 0x0001a4a1,
  0x0014e57e, 0x0019e4a7, 0x000a0588, 0x001272e4
};
/*
  Result of 32bit shv left (res = [bitshift in decimals])
  res = [22]
  res = 0xc6c000007580000033c00000a0000000c1800000c080000046800000bac00000
*/
static const uint32_t exp_shv_2[] = {
  0xbac00000, 0x46800000, 0xc0800000, 0xc1800000,
  0xa0000000, 0x33c00000, 0x75800000, 0xc6c00000
};
// Buffer to read back from OTBN
static uint32_t res_shv_1 [8];
static uint32_t res_shv_2 [8];

/*************
 * BN.TRN1/2 *
 *************/
/*
  32bit vector a for instruction trn1/2
  vec32a = n/a
  vec32a = 0x21caff82bc486be36aaecc11ccdd1e5621164f9c456fec1611a7c626ee821bdb
*/
static const uint32_t vec_a_trn[] = {
  0xee821bdb, 0x11a7c626, 0x456fec16, 0x21164f9c,
  0xccdd1e56, 0x6aaecc11, 0xbc486be3, 0x21caff82
};
/*
  32bit vector b for instruction trn1/2
  vec32b = n/a
  vec32b = 0x489bc5561f6b6e6b99c19e9f26795d6dbd9a16d9ff11c45542568d446c0130d1
*/
static const uint32_t vec_b_trn[] = {
  0x6c0130d1, 0x42568d44, 0xff11c455, 0xbd9a16d9,
  0x26795d6d, 0x99c19e9f, 0x1f6b6e6b, 0x489bc556
};
/*
  Result of 32bit trn1
  res = n/a
  res = 0x1f6b6e6bbc486be326795d6dccdd1e56ff11c455456fec166c0130d1ee821bdb
*/
static const uint32_t exp_trn1_32[] = {
  0xee821bdb, 0x6c0130d1, 0x456fec16, 0xff11c455,
  0xccdd1e56, 0x26795d6d, 0xbc486be3, 0x1f6b6e6b
};
/*
  Result of 64bit trn1
  res = n/a
  res = 0x99c19e9f26795d6d6aaecc11ccdd1e5642568d446c0130d111a7c626ee821bdb
*/
static const uint32_t exp_trn1_64[] = {
  0xee821bdb, 0x11a7c626, 0x6c0130d1, 0x42568d44,
  0xccdd1e56, 0x6aaecc11, 0x26795d6d, 0x99c19e9f
};
/*
  Result of 128bit trn1
  res = n/a
  res = 0xbd9a16d9ff11c45542568d446c0130d121164f9c456fec1611a7c626ee821bdb
*/
static const uint32_t exp_trn1_128[] = {
  0xee821bdb, 0x11a7c626, 0x456fec16, 0x21164f9c,
  0x6c0130d1, 0x42568d44, 0xff11c455, 0xbd9a16d9
};
/*
  Result of 32bit trn2
  res = n/a
  res = 0x489bc55621caff8299c19e9f6aaecc11bd9a16d921164f9c42568d4411a7c626
*/
static const uint32_t exp_trn2_32[] = {
  0x11a7c626, 0x42568d44, 0x21164f9c, 0xbd9a16d9,
  0x6aaecc11, 0x99c19e9f, 0x21caff82, 0x489bc556
};
/*
  Result of 64bit trn2
  res = n/a
  res = 0x489bc5561f6b6e6b21caff82bc486be3bd9a16d9ff11c45521164f9c456fec16
*/
static const uint32_t exp_trn2_64[] = {
  0x456fec16, 0x21164f9c, 0xff11c455, 0xbd9a16d9,
  0xbc486be3, 0x21caff82, 0x1f6b6e6b, 0x489bc556
};
/*
  Result of 128bit trn2
  res = n/a
  res = 0x489bc5561f6b6e6b99c19e9f26795d6d21caff82bc486be36aaecc11ccdd1e56
*/
static const uint32_t exp_trn2_128[] = {
  0xccdd1e56, 0x6aaecc11, 0xbc486be3, 0x21caff82,
  0x26795d6d, 0x99c19e9f, 0x1f6b6e6b, 0x489bc556
};
// Buffer to read back from OTBN
static uint32_t res_trn1_32  [8];
static uint32_t res_trn1_64  [8];
static uint32_t res_trn1_128 [8];
static uint32_t res_trn2_32  [8];
static uint32_t res_trn2_64  [8];
static uint32_t res_trn2_128 [8];

/***********
 * BN.MULV *
 ***********/
/*
  32bit vector a for instruction mulv
  vec32a0 = [0, 1, 44913, 9734, 23276, 65251, 13010, 40903]
  vec32a0 = 0x00000000000000010000af710000260600005aec0000fee3000032d200009fc7
*/
static const uint32_t vec_a_mulv[] = {
  0x00009fc7, 0x000032d2, 0x0000fee3, 0x00005aec,
  0x00002606, 0x0000af71, 0x00000001, 0x00000000,
};
/*
  32bit vector vec32b0 for instruction mulv
  vec32b0 = [4140082361, 1869666356, 636760, 207841, 59661, 52504, 947, 30691]
  vec32b0 = 0xf6c4a4b96f70d8340009b75800032be10000e90d0000cd18000003b3000077e3
*/
static const uint32_t vec_b_mulv[] = {
  0x000077e3, 0x000003b3, 0x0000cd18, 0x0000e90d,
  0x00032be1, 0x0009b758, 0x6f70d834, 0xf6c4a4b9
};
/*
  Result of 32bit mulv
  res = [0, 1869666356, 2828998104, 2023124294, 1388669436, 3425938504, 12320470, 1255353973]
  res = 0x000000006f70d834a89f15d878966d4652c569fccc33ac4800bbfed64ad32e75
*/
static const uint32_t exp_mulv[] = {
  0x4ad32e75, 0x00bbfed6, 0xcc33ac48, 0x52c569fc,
  0x78966d46, 0xa89f15d8, 0x6f70d834, 0x00000000
};
// Buffer to read back from OTBN
static uint32_t res_mulv [8];

/************
 * BN.MULVL *
 ************/
// same input vectors as for BN.MULV
/*
  Result of 32bit mulvl index 5
  res = [0, 636760, 2828998104, 1903254544, 1936323872, 2894521096, 3989280304, 275590504]
  res = 0x000000000009b758a89f15d871715c107369f520ac86e308edc79630106d2d68
*/
static const uint32_t exp_mulvl[] = {
  0x106d2d68, 0xedc79630, 0xac86e308, 0x7369f520,
  0x71715c10, 0xa89f15d8, 0x0009b758, 0x00000000
};
// Buffer to read back from OTBN
static uint32_t res_mulvl [8];

/************
 * BN.MULVM *
 ************/
/*
  32bit vector a for instruction mulvm
  vec32a0 = [140140, 2179652, 4415585, 3591344, 6089560, 5367875, 2289882, 4817594]
  vec32a0 = 0x0002236c00214244004360610036ccb0005ceb580051e8430022f0da004982ba
*/
static const uint32_t vec_a_mulvm[] = {
  0x004982ba, 0x0022f0da, 0x0051e843, 0x005ceb58,
  0x0036ccb0, 0x00436061, 0x00214244, 0x0002236c
};
/*
  32bit vector b for instruction mulvm
  vec32b0 = [7268407, 3661137, 7621524, 6778366, 6274350, 2059156, 3886783, 2027657]
  vec32b0 = 0x006ee8370037dd5100744b9400676dfe005fbd2e001f6b94003b4ebf001ef089
*/
static const uint32_t vec_b_mulvm[] = {
  0x001ef089, 0x003b4ebf, 0x001f6b94, 0x005fbd2e,
  0x00676dfe, 0x00744b94, 0x0037dd51, 0x006ee837
};
/*
  Result of 32bit mulvm
  res = [1620927, 7309254, 1234587, 1342470, 3140778, 8169851, 1752570, 480708]
  res = 0x0018bbbf006f87c60012d69b00147c06002fecaa007ca97b001abdfa000755c4
*/
static const uint32_t exp_mulvm[] = {
  0x000755c4, 0x001abdfa, 0x007ca97b, 0x002fecaa,
  0x00147c06, 0x0012d69b, 0x006f87c6, 0x0018bbbf
};
// Buffer to read back from OTBN
static uint32_t res_mulvm [8];

/*************
 * BN.MULVML *
 *************/
// Same input vectors as BN.MULVM
/*
  Result of 32bit mulvlm index 5
  res = [1232565, 270074, 1234587, 1770294, 4286072, 2244601, 428083, 1636517]
  res = 0x0012ceb500041efa0012d69b001b03360041667800223ff9000688330018f8a5
*/
static const uint32_t exp_mulvml[] = {
  0x0018f8a5, 0x00068833, 0x00223ff9, 0x00416678,
  0x001b0336, 0x0012d69b, 0x00041efa, 0x0012ceb5
};
// Buffer to read back from OTBN
static uint32_t res_mulvml [8];

/***********
 * BN.PACK *
 ***********/
static const uint32_t vec_pack[] = {
  0xEEFFFFFF, 0xEEFFFFFF, 0xEEFFFFFF, 0xEEFFFFFF,
  0xEEFFFFFF, 0xEEFFFFFF, 0xEEFFFFFF, 0xEEFFFFFF,
};
static const uint32_t exp_pack[] = {
  0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
  0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, 0x00000000
};
// Buffer to read back from OTBN
static uint32_t res_pack [8];

/***********
 * BN.UNPK *
 ***********/
static const uint32_t vec_unpk[] = {
  0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
  0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, 0x00000000
};
static const uint32_t exp_unpk[] = {
  0x00FFFFFF, 0x00FFFFFF, 0x00FFFFFF, 0x00FFFFFF,
  0x00FFFFFF, 0x00FFFFFF, 0x00FFFFFF, 0x00FFFFFF,
};
// Buffer to read back from OTBN
static uint32_t res_unpk [8];
// clang-format on

/****************
 * OTBN symbols *
 ****************/
OTBN_DECLARE_APP_SYMBOLS(vectorized_test);

OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, mod32);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, mod32_montg);

OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_a_addv);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_b_addv);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_a_addvm);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_b_addvm);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_a_subv);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_b_subv);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_a_subvm);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_b_subvm);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_shv);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_a_trn);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_b_trn);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_a_mulv);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_b_mulv);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_a_mulvm);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_b_mulvm);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_pack);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, vec_unpk);

OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_addv);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_addvm);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_subv);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_subvm);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_shv_1);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_shv_2);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_trn1_32);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_trn1_64);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_trn1_128);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_trn2_32);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_trn2_64);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_trn2_128);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_mulv);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_mulvl);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_mulvm);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_mulvml);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_pack);
OTBN_DECLARE_SYMBOL_ADDR(vectorized_test, res_unpk);

static const otbn_app_t kAppVectorizedTest = OTBN_APP_T_INIT(vectorized_test);
// clang-format off
static const otbn_addr_t k_mod32       = OTBN_ADDR_T_INIT(vectorized_test, mod32);
static const otbn_addr_t k_mod32_montg = OTBN_ADDR_T_INIT(vectorized_test, mod32_montg);

static const otbn_addr_t k_vec_a_addv  = OTBN_ADDR_T_INIT(vectorized_test, vec_a_addv);
static const otbn_addr_t k_vec_b_addv  = OTBN_ADDR_T_INIT(vectorized_test, vec_b_addv);
static const otbn_addr_t k_vec_a_addvm = OTBN_ADDR_T_INIT(vectorized_test, vec_a_addvm);
static const otbn_addr_t k_vec_b_addvm = OTBN_ADDR_T_INIT(vectorized_test, vec_b_addvm);
static const otbn_addr_t k_vec_a_subv  = OTBN_ADDR_T_INIT(vectorized_test, vec_a_subv);
static const otbn_addr_t k_vec_b_subv  = OTBN_ADDR_T_INIT(vectorized_test, vec_b_subv);
static const otbn_addr_t k_vec_a_subvm = OTBN_ADDR_T_INIT(vectorized_test, vec_a_subvm);
static const otbn_addr_t k_vec_b_subvm = OTBN_ADDR_T_INIT(vectorized_test, vec_b_subvm);
static const otbn_addr_t k_vec_shv     = OTBN_ADDR_T_INIT(vectorized_test, vec_shv);
static const otbn_addr_t k_vec_a_trn   = OTBN_ADDR_T_INIT(vectorized_test, vec_a_trn);
static const otbn_addr_t k_vec_b_trn   = OTBN_ADDR_T_INIT(vectorized_test, vec_b_trn);
static const otbn_addr_t k_vec_a_mulv  = OTBN_ADDR_T_INIT(vectorized_test, vec_a_mulv);
static const otbn_addr_t k_vec_b_mulv  = OTBN_ADDR_T_INIT(vectorized_test, vec_b_mulv);
static const otbn_addr_t k_vec_a_mulvm = OTBN_ADDR_T_INIT(vectorized_test, vec_a_mulvm);
static const otbn_addr_t k_vec_b_mulvm = OTBN_ADDR_T_INIT(vectorized_test, vec_b_mulvm);
static const otbn_addr_t k_vec_pack    = OTBN_ADDR_T_INIT(vectorized_test, vec_pack);
static const otbn_addr_t k_vec_unpk    = OTBN_ADDR_T_INIT(vectorized_test, vec_unpk);

static const otbn_addr_t k_res_addv     = OTBN_ADDR_T_INIT(vectorized_test, res_addv);
static const otbn_addr_t k_res_addvm    = OTBN_ADDR_T_INIT(vectorized_test, res_addvm);
static const otbn_addr_t k_res_subv     = OTBN_ADDR_T_INIT(vectorized_test, res_subv);
static const otbn_addr_t k_res_subvm    = OTBN_ADDR_T_INIT(vectorized_test, res_subvm);
static const otbn_addr_t k_res_shv_1    = OTBN_ADDR_T_INIT(vectorized_test, res_shv_1);
static const otbn_addr_t k_res_shv_2    = OTBN_ADDR_T_INIT(vectorized_test, res_shv_2);
static const otbn_addr_t k_res_trn1_32  = OTBN_ADDR_T_INIT(vectorized_test, res_trn1_32);
static const otbn_addr_t k_res_trn1_64  = OTBN_ADDR_T_INIT(vectorized_test, res_trn1_64);
static const otbn_addr_t k_res_trn1_128 = OTBN_ADDR_T_INIT(vectorized_test, res_trn1_128);
static const otbn_addr_t k_res_trn2_32  = OTBN_ADDR_T_INIT(vectorized_test, res_trn2_32);
static const otbn_addr_t k_res_trn2_64  = OTBN_ADDR_T_INIT(vectorized_test, res_trn2_64);
static const otbn_addr_t k_res_trn2_128 = OTBN_ADDR_T_INIT(vectorized_test, res_trn2_128);
static const otbn_addr_t k_res_mulv     = OTBN_ADDR_T_INIT(vectorized_test, res_mulv);
static const otbn_addr_t k_res_mulvl    = OTBN_ADDR_T_INIT(vectorized_test, res_mulvl);
static const otbn_addr_t k_res_mulvm    = OTBN_ADDR_T_INIT(vectorized_test, res_mulvm);
static const otbn_addr_t k_res_mulvml   = OTBN_ADDR_T_INIT(vectorized_test, res_mulvml);
static const otbn_addr_t k_res_pack     = OTBN_ADDR_T_INIT(vectorized_test, res_pack);
static const otbn_addr_t k_res_unpk     = OTBN_ADDR_T_INIT(vectorized_test, res_unpk);
// clang-format on

static_assert(kDtOtbnCount >= 1,
              "This test requires at least one OTBN instance");

static dt_otbn_t kTestOtbn = (dt_otbn_t)0;

OTTF_DEFINE_TEST_CONFIG();

static void check_results(uint32_t *result, const uint32_t *expected,
                          uint32_t nofElem, char *name) {
  // Test the results
  for (int i = 0; i < nofElem; ++i) {
    CHECK(result[i] == expected[i],
          "Unexpected result at element %d: 0x%x (actual) != 0x%x (expected) "
          "for %s",
          i, result[i], expected[i], name);
  }
}

/**
 * Run a smoketest using all vectorized instructions.
 * The code executed on OTBN can be found in:
 * sw/otbn/vectorized/vectorized_test.s
 */
static void test_vectorized(dif_otbn_t *otbn) {
  // Copy application to OTBN DMEM
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppVectorizedTest));

  // clang-format off
  // Copy data to DMEM
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, mod32,       k_mod32));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, mod32_montg, k_mod32_montg));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_a_addv,  k_vec_a_addv));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_b_addv,  k_vec_b_addv));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_a_addvm, k_vec_a_addvm));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_b_addvm, k_vec_b_addvm));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_a_subv,  k_vec_a_subv));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_b_subv,  k_vec_b_subv));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_a_subvm, k_vec_a_subvm));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_b_subvm, k_vec_b_subvm));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_shv,     k_vec_shv));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_a_trn,   k_vec_a_trn));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_b_trn,   k_vec_b_trn));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_a_mulv,  k_vec_a_mulv));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_b_mulv,  k_vec_b_mulv));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_a_mulvm, k_vec_a_mulvm));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_b_mulvm, k_vec_b_mulvm));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_pack,    k_vec_pack));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 256/8, vec_unpk,    k_vec_unpk));
  // clang-format on

  // Run application
  CHECK_DIF_OK(dif_otbn_set_ctrl_software_errs_fatal(otbn, true));
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));
  CHECK(dif_otbn_set_ctrl_software_errs_fatal(otbn, false) == kDifUnavailable);
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));

  // clang-format off
  // Read back results
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_addv,     res_addv));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_addvm,    res_addvm));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_subv,     res_subv));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_subvm,    res_subvm));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_shv_1,    res_shv_1));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_shv_2,    res_shv_2));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_trn1_32,  res_trn1_32));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_trn1_64,  res_trn1_64));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_trn1_128, res_trn1_128));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_trn2_32,  res_trn2_32));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_trn2_64,  res_trn2_64));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_trn2_128, res_trn2_128));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_mulv,     res_mulv));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_mulvl,    res_mulvl));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_mulvm,    res_mulvm));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_mulvml,   res_mulvml));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_pack,     res_pack));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, 256/8, k_res_unpk,     res_unpk));

  // Check results
  check_results(res_addv,     exp_addv,     8, "addv");
  check_results(res_addvm,    exp_addvm,    8, "addvm");
  check_results(res_subv,     exp_subv,     8, "subv");
  check_results(res_subvm,    exp_subvm,    8, "subvm");
  check_results(res_shv_1,    exp_shv_1,    8, "shv_1");
  check_results(res_shv_2,    exp_shv_2,    8, "shv_2");
  check_results(res_trn1_32,  exp_trn1_32,  8, "trn1_32");
  check_results(res_trn1_64,  exp_trn1_64,  8, "trn1_64");
  check_results(res_trn1_128, exp_trn1_128, 8, "trn1_128");
  check_results(res_trn2_32,  exp_trn2_32,  8, "trn2_32");
  check_results(res_trn2_64,  exp_trn2_64,  8, "trn2_64");
  check_results(res_trn2_128, exp_trn2_128, 8, "trn2_128");
  check_results(res_mulv,     exp_mulv,     8, "mulv");
  check_results(res_mulvl,    exp_mulvl,    8, "mulvl");
  check_results(res_mulvm,    exp_mulvm,    8, "mulvm");
  check_results(res_mulvml,   exp_mulvml,   8, "mulvml");
  check_results(res_pack,     exp_pack,     8, "pack");
  check_results(res_unpk,     exp_unpk,     8, "unpk");
  // clang-format on
}

bool test_main(void) {
  CHECK_STATUS_OK(entropy_testutils_auto_mode_init());

  dif_otbn_t otbn;
  CHECK_DIF_OK(dif_otbn_init_from_dt(kTestOtbn, &otbn));

  test_vectorized(&otbn);

  return true;
}
