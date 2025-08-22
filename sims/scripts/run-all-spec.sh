#!/usr/bin/env bash
set -euo pipefail

NORMAL_SPECS=(
  "spec17-intrate-ref-500|Boom|3|1|xilinx_vcu118_firesim_boom_1GB_no_nic_large_scalar_counters"
  "spec17-intrate-ref-505|Boom|3|1|xilinx_vcu118_firesim_boom_1GB_no_nic_large_scalar_counters"
  "spec17-intrate-ref-520|Boom|3|1|xilinx_vcu118_firesim_boom_1GB_no_nic_large_scalar_counters"
  "spec17-intrate-ref-523|Boom|3|1|xilinx_vcu118_firesim_boom_1GB_no_nic_large_scalar_counters"
  "spec17-intrate-ref-525|Boom|3|1|xilinx_vcu118_firesim_boom_1GB_no_nic_large_scalar_counters"
  "spec17-intrate-ref-541|Boom|3|1|xilinx_vcu118_firesim_boom_1GB_no_nic_large_scalar_counters"
  "spec17-intrate-ref-548|Boom|3|1|xilinx_vcu118_firesim_boom_1GB_no_nic_large_scalar_counters"
  "spec17-intrate-ref-557|Boom|3|1|xilinx_vcu118_firesim_boom_1GB_no_nic_large_scalar_counters"
)

for entry in "${NORMAL_SPECS[@]}"; do
  IFS='|' read -r JSON CORE COREWIDTH SCALAR HW <<< "$entry"
  make spec-workload \
       JSON="$JSON" \
       CORE="$CORE" \
       COREWIDTH="$COREWIDTH" \
       ${SCALAR:+SCALAR="$SCALAR"}
  make run \
       HW="$HW" \
       WORKLOAD="$JSON.json"
done