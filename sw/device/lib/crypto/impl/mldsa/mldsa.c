// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/crypto/impl/mldsa/mldsa.h"

#include "sw/device/lib/base/hardened.h"
#include "sw/device/lib/base/hardened_memory.h"
#include "sw/device/lib/crypto/drivers/otbn.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

#include "sw/device/lib/runtime/log.h"

// Module ID for status codes.
#define MODULE_ID MAKE_MODULE_ID('m', 'l', 'd')

// OTBN app.
OTBN_DECLARE_APP_SYMBOLS(mldsa87_verify);
// Inputs.
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_verify, mldsa87_verify_pk);
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_verify, mldsa87_verify_sig);
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_verify, mldsa87_verify_mu);
// Outputs.
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_verify, mldsa87_verify_res_ok);
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_verify, mldsa87_verify_res_c_tilde_prime);


OTBN_DECLARE_APP_SYMBOLS(mldsa87_sign);
// Inputs
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_sign, mldsa87_sign_rnd);
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_sign, mldsa87_sign_kappa);
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_sign, mldsa87_sign_sk);
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_sign, mldsa87_sign_mu);
// Outputs
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_sign, mldsa87_sign_sig_c_tilde);
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_sign, mldsa87_sign_sig_z);
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_sign, mldsa87_sign_sig_h);

OTBN_DECLARE_SYMBOL_ADDR(mldsa87_sign, mldsa87_sign_var_rho_prime_share0);
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_sign, mldsa87_sign_var_rho_prime_share1);

OTBN_DECLARE_SYMBOL_ADDR(mldsa87_sign, mldsa87_sign_sk_k_share0);
OTBN_DECLARE_SYMBOL_ADDR(mldsa87_sign, mldsa87_sign_sk_k_share1);

OTBN_DECLARE_SYMBOL_ADDR(mldsa87_sign, mldsa87_sign_var_c);

status_t mldsa87_sign_internal_start(
    const otcrypto_blinded_key_t *secret_key,
    const otcrypto_const_word32_buf_t *rnd,
    const otcrypto_const_word32_buf_t *kappa,
    const otcrypto_hash_digest_t *mu) {
  // Load the ML-DSA-87 sign app and write the inputs.
  const otbn_app_t kOtbnAppMldsa87Sign = OTBN_APP_T_INIT(mldsa87_sign);
  HARDENED_TRY(otbn_load_app(kOtbnAppMldsa87Sign));

  const otbn_addr_t kOtbnRnd =
      OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_rnd);
  HARDENED_TRY(otbn_dmem_write(rnd->len, rnd->data, kOtbnRnd));

  const otbn_addr_t kOtbnKappa =
      OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_kappa);
  HARDENED_TRY(otbn_dmem_write(kappa->len, kappa->data, kOtbnKappa));

  const otbn_addr_t kOtbnSk =
      OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_sk);
  HARDENED_TRY(otbn_dmem_write(secret_key->keyblob_length / sizeof(uint32_t),
                               secret_key->keyblob, kOtbnSk));

  const otbn_addr_t kOtbnMu =
      OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_mu);
  HARDENED_TRY(otbn_dmem_write(mu->len, mu->data, kOtbnMu));

  return otbn_execute();
}

status_t mldsa87_sign_internal_finalize(
    otcrypto_word32_buf_t *signature) {
  // Stall until the OTBN finishes.
  HARDENED_TRY(otbn_busy_wait_for_done());

  // Load c_tilde_prime.
  const otbn_addr_t kOtbnCTilde =
      OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_sig_c_tilde);
  HARDENED_TRY(otbn_dmem_read(kMldsa87CTildeWords, kOtbnCTilde,
                              signature->data));

  // Load Z.
  const otbn_addr_t kOtbnZ =
      OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_sig_z);
  HARDENED_TRY(otbn_dmem_read(kMldsa87ZWords, kOtbnZ,
                              signature->data + kMldsa87CTildeWords));

  // Load hint.
  const otbn_addr_t kOtbnH =
      OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_sig_h);
  HARDENED_TRY(otbn_dmem_read(kMldsa87HWords, kOtbnH,
                              signature->data + kMldsa87CTildeWords + kMldsa87ZWords));


  const otbn_addr_t kPrime0 = OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_var_rho_prime_share0);
  const otbn_addr_t kPrime1 = OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_var_rho_prime_share1);

  const otbn_addr_t kK0 = OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_sk_k_share0);
  const otbn_addr_t kK1 = OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_sk_k_share1);

  const otbn_addr_t kRnd = OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_rnd);

  const otbn_addr_t kMu = OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_mu);

  const otbn_addr_t kKappa = OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_kappa);

  const otbn_addr_t kC = OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_var_c);

  const otbn_addr_t kS10 = OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_sk_s1_share0);
  const otbn_addr_t kS11 = OTBN_ADDR_T_INIT(mldsa87_sign, mldsa87_sign_sk_s1_share1);

  uint32_t p0[16];
  uint32_t p1[16];
  HARDENED_TRY(otbn_dmem_read(16, kPrime0, p0));
  HARDENED_TRY(otbn_dmem_read(16, kPrime1, p1));

  uint32_t k0[8];
  uint32_t k1[8];
  HARDENED_TRY(otbn_dmem_read(8, kK0, k0));
  HARDENED_TRY(otbn_dmem_read(8, kK1, k1));

  uint32_t rnd[8];
  HARDENED_TRY(otbn_dmem_read(8, kRnd, rnd));

  uint32_t mu[16];
  HARDENED_TRY(otbn_dmem_read(16, kMu, mu));

  uint32_t kappa[8];
  HARDENED_TRY(otbn_dmem_read(8, kKappa, kappa));


  uint32_t c[8];
  HARDENED_TRY(otbn_dmem_read(8, kC, c));

  uint32_t s0[168];
  uint32_t s1[168];
  HARDENED_TRY(otbn_dmem_read(168, kS10, s0));
  HARDENED_TRY(otbn_dmem_read(168, kS11, s1));

  LOG_INFO("-----------> %08x", p0[0] ^ p1[0]);
  LOG_INFO("-----------> %08x", k0[7] ^ k1[7]);
  LOG_INFO("-----------> %08x", rnd[0]);
  LOG_INFO("-----------> %08x", mu[0]);
  LOG_INFO("-----------> %08x", signature->data[0]);
  LOG_INFO("-----------> %08x", kappa[0]);
  LOG_INFO("-----------> %08x", c[1]);
  LOG_INFO("-----------> %08x", s0[167] ^ s1[167]);

  /* for (int i = 0; i < 100; i++) { */
  /*   LOG_INFO("1111111111111111 0x%08x", signature->data[i]); */
  /* } */
  

  return otbn_dmem_sec_wipe();
}

status_t mldsa87_verify_internal_start(
    const otcrypto_unblinded_key_t *public_key,
    const otcrypto_const_word32_buf_t *signature,
    const otcrypto_hash_digest_t *mu) {
  // Load the ML-DSA-87 verification app and write the inputs.
  const otbn_app_t kOtbnAppMldsa87Verify = OTBN_APP_T_INIT(mldsa87_verify);
  HARDENED_TRY(otbn_load_app(kOtbnAppMldsa87Verify));

  const otbn_addr_t kOtbnPk =
      OTBN_ADDR_T_INIT(mldsa87_verify, mldsa87_verify_pk);
  HARDENED_TRY(otbn_dmem_write(public_key->key_length / sizeof(uint32_t),
                               public_key->key, kOtbnPk));

  const otbn_addr_t kOtbnSig =
      OTBN_ADDR_T_INIT(mldsa87_verify, mldsa87_verify_sig);
  HARDENED_TRY(otbn_dmem_write(signature->len, signature->data, kOtbnSig));

  const otbn_addr_t kOtbnMu =
      OTBN_ADDR_T_INIT(mldsa87_verify, mldsa87_verify_mu);
  HARDENED_TRY(otbn_dmem_write(mu->len, mu->data, kOtbnMu));

  return otbn_execute();
}

status_t mldsa87_verify_internal_finalize(
    const otcrypto_const_word32_buf_t *signature, hardened_bool_t *result) {
  // Stall until the OTBN finishes.
  HARDENED_TRY(otbn_busy_wait_for_done());

  *result = kHardenedBoolFalse;

  // Load the status flag and make sure no error has been thrown by the app.
  uint32_t ok;
  const otbn_addr_t kOtbnOk =
      OTBN_ADDR_T_INIT(mldsa87_verify, mldsa87_verify_res_ok);
  HARDENED_TRY(otbn_dmem_read(1, kOtbnOk, &ok));
  if (launder32(ok) != kMldsa87StatusOk) {
    return OTCRYPTO_BAD_ARGS;
  }
  HARDENED_CHECK_EQ(ok, kMldsa87StatusOk);

  // Load c_tilde_prime and compare it against the signature.
  uint32_t c_tilde_prime[kMldsa87CTildePrimeWords];
  const otbn_addr_t kOtbnCTildePrime =
      OTBN_ADDR_T_INIT(mldsa87_verify, mldsa87_verify_res_c_tilde_prime);
  HARDENED_TRY(otbn_dmem_read(kMldsa87CTildePrimeWords, kOtbnCTildePrime,
                              c_tilde_prime));

  *result =
      hardened_memeq(signature->data, c_tilde_prime, kMldsa87CTildePrimeWords);

  return otbn_dmem_sec_wipe();
}
