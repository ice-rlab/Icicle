#!/bin/bash

# This script runs the IISWC 2025 AE benchmarks with specific configurations.
# If an FPGA is available, replace all "make meta-run" with "make run" commands.
# We stress that we there will be slight differences with verilator simulations as opposed to simulations on an FPGA due to different memory models and some slight difference in simulation startup.
# Assumes environemnt is already built and source env.sh is run. This script only runs microbenchmarks using metasimulation

set -euo pipefail
source $PC_DIR/scripts/env/util.sh

make init

make trace_decoder

mkdir -p $PC_DIR/iiswc-2025-ae-out/

# clean out any old results
rm -rf $PC_DIR/iiswc-2025-ae-out/*

# =============All Rocket Workloads with TMA=============

# ------------Build all Rocket workloads ------------
make mergesort-trace-workload CORE=Rocket
make qsort-trace-workload CORE=Rocket
make dhrystone-bare-workload CORE=Rocket
make memcpy-bare-workload CORE=Rocket
make mm-bare-workload CORE=Rocket
make mt-matmul-bare-workload CORE=Rocket
make qsort_riscv_tests-bare-workload CORE=Rocket
make rsort-bare-workload CORE=Rocket
make towers-bare-workload CORE=Rocket
make branchmiss-bare-workload CORE=Rocket



# ----------Run TMA microbenchmarks (Figure 7. (a), (b)) ----------
mkdir -p $PC_DIR/iiswc-2025-ae-out/rocket/all

make meta-run HW=rocket WORKLOAD=dhrystone-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/rocket/all


make meta-run HW=rocket WORKLOAD=memcpy-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/rocket/all

make meta-run HW=rocket WORKLOAD=mm-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/rocket/all

make meta-run HW=rocket WORKLOAD=mt-matmul-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/rocket/all

make meta-run HW=rocket WORKLOAD=qsort_riscv_tests-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/rocket/all

make meta-run HW=rocket WORKLOAD=rsort-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/rocket/all

make meta-run HW=rocket WORKLOAD=towers-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/rocket/all

tma_tool --plot-tma $PC_DIR/iiswc-2025-ae-out/rocket/all --ipc -o $PC_DIR/iiswc-2025-ae-out/rocket/all --ipc --w 3.5 --h 2.5 --lh 1.18
tma_tool --plot-tma $PC_DIR/iiswc-2025-ae-out/rocket/all --ipc -o $PC_DIR/iiswc-2025-ae-out/rocket/all --ipc --w 3.5 --h 2.5 --lh 1.18 --cat Backend
tma_tool --plot-tma $PC_DIR/iiswc-2025-ae-out/rocket/all --ipc -o $PC_DIR/iiswc-2025-ae-out/rocket/all --ipc --w 3.5 --h 2.5 --lh 1.18 --cat Frontend
tma_tool --plot-tma $PC_DIR/iiswc-2025-ae-out/rocket/all --ipc -o $PC_DIR/iiswc-2025-ae-out/rocket/all --ipc --w 3.5 --h 2.5 --lh 1.18 --cat BadSpeculation
tma_tool --show-tma $PC_DIR/iiswc-2025-ae-out/rocket/all > $PC_DIR/iiswc-2025-ae-out/rocket/all/tma.txt


# ----------Run TMA case study 2: branch miss (Figure 7. (d))----------
mkdir -p $PC_DIR/iiswc-2025-ae-out/rocket/case-study-2/

make meta-run HW=rocket WORKLOAD=branchmiss-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/rocket/case-study-2

tma_tool --plot-tma $PC_DIR/iiswc-2025-ae-out/rocket/case-study-2/ --ipc -o $PC_DIR/iiswc-2025-ae-out/rocket/case-study-2/ --ipc --w 0.9 --h 2.5 --lh 1.18
tma_tool --show-tma $PC_DIR/iiswc-2025-ae-out/rocket/case-study-2 > $PC_DIR/iiswc-2025-ae-out/rocket/case-study-2/tma.txt



# --------------PMU architectures comparison---------------------

# This shows all the different PMU counters architectures in action. The distributed counters architecture requires post processing (left shift by counter width) for now and this artifact is set up for the scalar and add wires harness.


mkdir -p $PC_DIR/iiswc-2025-ae-out/counters-comparison
mkdir -p $PC_DIR/iiswc-2025-ae-out/counters-comparison/scalar
mkdir -p $PC_DIR/iiswc-2025-ae-out/counters-comparison/add_wires
mkdir -p $PC_DIR/iiswc-2025-ae-out/counters-comparison/distributed_counters

make mm-bare-workload CORE=Boom COREWIDTH=3 SCALAR=0
make meta-run HW=large_boom_scalar WORKLOAD=mm-bare.json

cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/counters-comparison/scalar


make mm-bare-workload CORE=Boom COREWIDTH=3 SCALAR=1
make meta-run HW=large_boom_add_wires WORKLOAD=mm-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/counters-comparison/add_wires


make meta-run HW=large_boom_distributed_counters WORKLOAD=mm-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/counters-comparison/distributed_counters

tma_tool --show-counters $PC_DIR/iiswc-2025-ae-out/counters-comparison > $PC_DIR/iiswc-2025-ae-out/counters-comparison/raw_counters.txt



# ---------Build all BOOM workloads ---------
make memcpy-bare-workload CORE=Boom COREWIDTH=3 SCALAR=0
make mm-bare-workload CORE=Boom COREWIDTH=3 SCALAR=0
make mt-matmul-bare-workload CORE=Boom COREWIDTH=3 SCALAR=0
make qsort_riscv_tests-bare-workload CORE=Boom COREWIDTH=3 SCALAR=0
make rsort-bare-workload CORE=Boom COREWIDTH=3 SCALAR=0
make towers-bare-workload CORE=Boom COREWIDTH=3 SCALAR=0
make branchmiss-bare-workload CORE=Boom COREWIDTH=3 SCALAR=0


mkdir -p $PC_DIR/iiswc-2025-ae-out/rocket


make meta-run HW=large_boom_add_wires WORKLOAD=dhrystone-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/boom/all

make meta-run HW=large_boom_add_wires WORKLOAD=memcpy-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/boom/all

make meta-run HW=large_boom_add_wires WORKLOAD=mm-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/boom/all

make meta-run HW=large_boom_add_wires WORKLOAD=mt-matmul-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/boom/all

make meta-run HW=large_boom_add_wires WORKLOAD=qsort_riscv_tests-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/boom/all

make meta-run HW=large_boom_add_wires WORKLOAD=rsort-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/boom/all

make meta-run HW=large_boom_add_wires WORKLOAD=towers-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/boom/all

tma_tool --plot-tma $PC_DIR/iiswc-2025-ae-out/boom/all --ipc -o $PC_DIR/iiswc-2025-ae-out/rocket/all --ipc --w 3.5 --h 2.5 --lh 1.18
tma_tool --plot-tma $PC_DIR/iiswc-2025-ae-out/boom/all --ipc -o $PC_DIR/iiswc-2025-ae-out/rocket/all --ipc --w 3.5 --h 2.5 --lh 1.18 --cat Backend
tma_tool --plot-tma $PC_DIR/iiswc-2025-ae-out/boom/all --ipc -o $PC_DIR/iiswc-2025-ae-out/rocket/all --ipc --w 3.5 --h 2.5 --lh 1.18 --cat Frontend
tma_tool --plot-tma $PC_DIR/iiswc-2025-ae-out/boom/all --ipc -o $PC_DIR/iiswc-2025-ae-out/rocket/all --ipc --w 3.5 --h 2.5 --lh 1.18 --cat BadSpeculation
tma_tool --show-tma $PC_DIR/iiswc-2025-ae-out/rocket/all > $PC_DIR/iiswc-2025-ae-out/rocket/all/tma.txt




# ----------Run TMA case study 2: branch miss (Figure 7. (n))----------
mkdir -p $PC_DIR/iiswc-2025-ae-out/boom/case-study-2/

make meta-run HW=large_boom_add_wires WORKLOAD=branchmiss-bare.json
cp -r "$(last_exp)" $PC_DIR/iiswc-2025-ae-out/boom/case-study-2

tma_tool --plot-tma $PC_DIR/iiswc-2025-ae-out/boom/case-study-2/ --ipc -o $PC_DIR/iiswc-2025-ae-out/boom/case-study-2/ --ipc --w 0.9 --h 2.5 --lh 1.18
tma_tool --show-tma $PC_DIR/iiswc-2025-ae-out/boom/case-study-2 > $PC_DIR/iiswc-2025-ae-out/boom/case-study-2/tma.txt




# =============Following experiments require FPGA to run=============
# follow firesim docs: https://docs.fires.im/en/latest/ to get started

# Running SPEC CPU2017 (only possible with FPGA and each simulation takes aroun 12-20 hours on VCU118)

#Make sure to have SPEC_DIR set to local install for speckle.

# make spec-workload JSON=spec17-intrate-ref-500 CORE=Boom COREWIDTH=3 SCALAR=1
# make run HW=large_boom_scalar WORKLOAD=spec17-intrate-ref-500.json 
# make spec-workload JSON=spec17-intrate-ref-523 CORE=Boom COREWIDTH=3 SCALAR=1
# make run HW=large_boom_scalar WORKLOAD=spec17-intrate-ref-523.json 
# make spec-workload JSON=spec17-intrate-ref-525 CORE=Boom COREWIDTH=3 SCALAR=1
# make run HW=large_boom_scalar WORKLOAD=spec17-intrate-ref-525.json
# make spec-workload JSON=spec17-intrate-ref-548 CORE=Boom COREWIDTH=3 SCALAR=1 
# make run HW=large_boom_scalar WORKLOAD=spec17-intrate-ref-548.json
# make spec-workload JSON=spec17-intrate-ref-557 CORE=Boom COREWIDTH=3 SCALAR=1 
# make run HW=large_boom_scalar WORKLOAD=spec17-intrate-ref-557.json

# Running coremark casestudy workloads 
# make coremark-workload CORE=Rocket JSON=coremark-casestudy
# make run HW=rocket WORKLOAD=coremark-casestudy.json
# make coremark-workload CORE=Boo COREWIDTH=3 SCALAR=1 JSON=coremark-casestudy
# make run HW=large_boom_scalar WORKLOAD=coremark-casestudy.json