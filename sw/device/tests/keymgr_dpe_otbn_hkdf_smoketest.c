// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stdbool.h>
#include <stdint.h>

#include "sw/device/lib/arch/device.h"
#include "sw/device/lib/base/macros.h"
#include "sw/device/lib/dif/dif_keymgr_dpe.h"
#include "sw/device/lib/dif/dif_otbn.h"
#include "sw/device/lib/runtime/hart.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/runtime/print.h"
#include "sw/device/lib/testing/entropy_testutils.h"
#include "sw/device/lib/testing/keymgr_dpe_testutils.h"
#include "sw/device/lib/testing/otbn_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_alerts.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"

#include "hw/top/otbn_regs.h"  // Generated.
#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

static dif_keymgr_dpe_t keymgr_dpe;
static dif_kmac_t kmac;
static dif_otbn_t otbn;

static const dt_otbn_t kOtbnDt = (dt_otbn_t)0;

// OTBN application servicing the keymgr KDF interface. It receives the message
// and returns a fixed response that the host places in DMEM.
OTBN_DECLARE_APP_SYMBOLS(keymgr_test);
OTBN_DECLARE_SYMBOL_ADDR(keymgr_test, response);
static const otbn_app_t kOtbnAppKeymgrTest = OTBN_APP_T_INIT(keymgr_test);
static const otbn_addr_t kOtbnResponseAddr =
    OTBN_ADDR_T_INIT(keymgr_test, response);

// Fixed response returned by the OTBN app (share 0, 512 bits).
static const uint8_t kOtbnResponse[64] = {
    0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,  //
    0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff,  //
    0x0f, 0x1e, 0x2d, 0x3c, 0x4b, 0x5a, 0x69, 0x78,  //
    0x87, 0x96, 0xa5, 0xb4, 0xc3, 0xd2, 0xe1, 0xf0,  //
    0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,  //
    0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff,  //
    0x0f, 0x1e, 0x2d, 0x3c, 0x4b, 0x5a, 0x69, 0x78,  //
    0x87, 0x96, 0xa5, 0xb4, 0xc3, 0xd2, 0xe1, 0xf0,  //
};

OTTF_DEFINE_TEST_CONFIG();

/**
 * Parameters for advancing a DPE context
 */
static const dif_keymgr_dpe_advance_params_t kOtbnKdfDpeContext = {
    .binding_value = {0xdc96c23d, 0xaf36e268, 0xcb68ff71, 0xe92f76e2,
                      0xb8a8379d, 0x426dc745, 0x19f5cff7, 0x4ec9c6d6},
    .max_key_version = 0x11,
    .slot_src_sel = kCreatorRootKeyParams.slot_dst_sel,
    .slot_dst_sel = kCreatorRootKeyParams.slot_dst_sel,
    .slot_policy = 1  // 0b001 Allow children without retaining the parent
};

/**
 * Smoketest which uses the OTBN as KDF
 */
static void test_otbn_kdf(dif_keymgr_dpe_t *keymgr_dpe, dif_otbn_t *otbn) {
  // Load the OTBN app and place the fixed response it returns in DMEM.
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kOtbnAppKeymgrTest));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, sizeof(kOtbnResponse),
                                            kOtbnResponse, kOtbnResponseAddr));

  // Start the OTBN program. It runs until the keymgr sends the message.
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));

  // Switch the KDF from `KMAC` to `OTBN`
  dif_keymgr_dpe_kdf_engine_t kdf_engine_selection = kDifKeymgrDpeKdfEngineOtbn;
  CHECK_DIF_OK(dif_keymgr_dpe_set_kdf_engine(keymgr_dpe, kdf_engine_selection));

  // Advance the DPE context with the parameter defined locally in kOtbnKdfDpeContext
  dif_keymgr_dpe_advance_params_t adv_params = kOtbnKdfDpeContext;
  CHECK_STATUS_OK(keymgr_dpe_testutils_advance_state(keymgr_dpe, &adv_params));

  // Verify OTBN finished and raised no error
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));
}

bool test_main(void) {
  // Start keymgr_dpe, generating CreatorRootKey into the slot defined by
  // kCreatorRootKeyParams(/sw/device/lib/testing/keymgr_dpe_testutils.h)
  CHECK_STATUS_OK(keymgr_dpe_testutils_startup(&keymgr_dpe, &kmac));
  CHECK_STATUS_OK(keymgr_dpe_testutils_check_state(
      &keymgr_dpe, kDifKeymgrDpeStateAvailable));
  // Init the otbn
  CHECK_DIF_OK(dif_otbn_init_from_dt(kOtbnDt, &otbn));
  // DV SYNC MESSAGE
  LOG_INFO("KeymgrDpe derived CreatorRootKey and removed the UDS");
  LOG_INFO("KeymgrDpe is ready for the OTBN KDF smoketest!");

  // Test OTBN sideloading.
  test_otbn_kdf(&keymgr_dpe, &otbn);

  // DV SYNC MESSAGE
  LOG_INFO("KeymgrDpe derived DPE context with the OTBN (HKDF)");

  return true;
}
