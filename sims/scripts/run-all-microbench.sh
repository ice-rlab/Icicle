#!/bin/bash

set -euo pipefail

BENCHMARKS=("memcpy" "mt-memcpy" "towers" "mm" "mt-matmul" "dhrystone" "rsort" "qsort_riscv_tests")

CONFIGS=(
  "xilinx_vcu118_firesim_boom_1GB_no_nic_large_scalar_counters|Boom|3"
  "boom_small_cache|Boom|3"
)

for config in "${CONFIGS[@]}"; do
  IFS='|' read -r HW CORE COREWIDTH <<< "$config"

  for BENCH in "${BENCHMARKS[@]}"; do
    make "${BENCH}-bare-workload" CORE="$CORE" COREWIDTH="$COREWIDTH" SCALAR=1

    make run-trace HW=$HW WORKLOAD=${BENCH}-bare.json
  done
done
