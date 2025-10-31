#!/bin/bash
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Runs the OTBN smoke test (builds software, build simulation, runs simulation
# and checks expected output)
#
# To test the vectorized bignum instructions pass 'vectorized' as first argument.

fail() {
    echo >&2 "OTBN SMOKE FAILURE: $*"
    exit 1
}

set -o pipefail
set -e

SCRIPT_DIR="$(dirname "$(readlink -e "${BASH_SOURCE[0]}")")"
UTIL_DIR="$(readlink -e "$SCRIPT_DIR/../../../../../util")" || \
  fail "Can't find OpenTitan util dir"

source "$UTIL_DIR/build_consts.sh"

if [[ "$1" == "vectorized" ]]; then
  SMOKE_EXE="smoke_test_vectorized"
  SMOKE_EXPECTED="smoke_vectorized_expected"
  # The expected results file must match exactly with the simulator output.
  NOF_LINES_EXPECTED=71
else
  SMOKE_EXE="smoke_test"
  SMOKE_EXPECTED="smoke_expected"
  # The expected results file must match exactly with the simulator output.
  NOF_LINES_EXPECTED=74
fi

SMOKE_BIN_DIR=$BIN_DIR/otbn/$SMOKE_EXE
SMOKE_SRC_DIR=$REPO_TOP/hw/ip/otbn/dv/smoke

mkdir -p $SMOKE_BIN_DIR

OTBN_UTIL=$REPO_TOP/hw/ip/otbn/util

$OTBN_UTIL/otbn_as.py -o $SMOKE_BIN_DIR/$SMOKE_EXE.o $SMOKE_SRC_DIR/$SMOKE_EXE.s || \
    fail "Failed to assemble $SMOKE_EXE.s"
$OTBN_UTIL/otbn_ld.py -o $SMOKE_BIN_DIR/$SMOKE_EXE.elf $SMOKE_BIN_DIR/$SMOKE_EXE.o || \
    fail "Failed to link $SMOKE_EXE.o"

(cd $REPO_TOP;
 fusesoc --cores-root=. run --target=sim --setup --build \
    --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:otbn_top_sim \
    --make_options="-j$(nproc)" || fail "HW Sim build failed")

RUN_LOG=`mktemp`
readonly RUN_LOG
# shellcheck disable=SC2064 # The RUN_LOG tempfile path should not change
trap "rm -rf $RUN_LOG" EXIT

timeout 5s \
  $REPO_TOP/build/lowrisc_ip_otbn_top_sim_0.1/sim-verilator/Votbn_top_sim \
  --load-elf=$SMOKE_BIN_DIR/$SMOKE_EXE.elf -t | tee $RUN_LOG

if [ $? -eq 124 ]; then
  fail "Simulation timeout"
fi

if [ $? -ne 0 ]; then
  fail "Simulator run failed"
fi

had_diff=0
grep -A $NOF_LINES_EXPECTED "Call Stack:" $RUN_LOG | diff -U3 $SMOKE_SRC_DIR/$SMOKE_EXPECTED.txt - || had_diff=1

if [ $had_diff == 0 ]; then
  echo "OTBN SMOKE PASS for program $SMOKE_EXE"
else
  fail "Simulator output does not match expected output for program $SMOKE_EXE"
fi
