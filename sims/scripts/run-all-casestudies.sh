#!/usr/bin/env bash
set -euo pipefail

# —————————————————————————————
# 1) Branch‐miss case
# —————————————————————————————
WORKLOAD=branchmiss-bare

for cfg in \
  "Rocket|xilinx_vcu118_firesim_rocket_singlecore_1GB_no_nic" \
  "Boom|xilinx_vcu118_firesim_boom_1GB_no_nic_large_scalar_counters"
do
  IFS='|' read -r CORE HW <<< "$cfg"
  EXTRA_ARGS=()
  if [[ $CORE == "Boom" ]]; then
    EXTRA_ARGS+=(COREWIDTH=3 SCALAR=1)
  fi

  # build
  make branchmiss-bare-workload CORE="$CORE" "${EXTRA_ARGS[@]}"
  # run
  make run HW="$HW" WORKLOAD="$WORKLOAD.json"
done


# —————————————————————————————
# 2) Spec17 “intrate-test-531” case (including small-cache variant)
# —————————————————————————————
WORKLOAD=spec17-intrate-test-531

for CORE in Rocket Boom; do
  # choose HW targets per core
  if [[ $CORE == "Rocket" ]]; then
    HWS=("xilinx_vcu118_firesim_rocket_singlecore_1GB_no_nic" "rocket_small_cache")
  else
    HWS=("xilinx_vcu118_firesim_boom_1GB_no_nic_large_scalar_counters" "boom_small_cache")
  fi

  EXTRA_ARGS=()
  if [[ $CORE == "Boom" ]]; then
    EXTRA_ARGS+=(COREWIDTH=3 SCALAR=1)
  fi

  make spec-workload JSON="$WORKLOAD" CORE="$CORE" "${EXTRA_ARGS[@]}"

  for HW in "${HWS[@]}"; do
    make run HW="$HW" WORKLOAD="$WORKLOAD.json"
  done
done


# —————————————————————————————
# 3) CoreMark case study
# —————————————————————————————
WORKLOAD=coremark-casestudy

for CORE in Rocket Boom; do
  EXTRA_ARGS=()
  if [[ $CORE == "Boom" ]]; then
    EXTRA_ARGS+=(COREWIDTH=3 SCALAR=1)
    HW="xilinx_vcu118_firesim_boom_1GB_no_nic_large_scalar_counters"
  else
    HW="xilinx_vcu118_firesim_rocket_singlecore_1GB_no_nic"
  fi

  # build
  make coremark-workload JSON="$WORKLOAD" CORE="$CORE" "${EXTRA_ARGS[@]}"
  # run
  make run HW="$HW" WORKLOAD="$WORKLOAD.json"
done