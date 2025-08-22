#!/bin/bash
source $PC_DIR/env.sh

mkdir -p $PC_DIR/iiswc-2025-ae-out/results/
rm -rf $PC_DIR/iiswc-2025-ae-out/results//*

mkdir -p $PC_DIR/iiswc-2025-ae-out/data/

# Get FPGA results data
wget https://zenodo.org/records/16916499/files/icicle-iiswc2025-data.tar.gz
tar -xvf icicle-iiswc2025-data.tar.gz -C $PC_DIR/iiswc-2025-ae-out/data


DATA_DIR=$PC_DIR/iiswc-2025-ae-out/data/


# Generate plots for all total TMA
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ --out total_all --ipc  -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ --out total_backend --cat Backend -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ --out total_frontend --cat Frontend -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ --out total_bad_spec --cat BadSpeculation -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ --out total_bad_spec --cat BrMispredictions -o $PC_DIR/iiswc-2025-ae-out/results/


# Run rocket plots
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ROCKET_MICRO --out rocket_micro --ipc --w 3.5 --h 2.5 --lh 1.18 -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ROCKET_MICRO --out rocket_micro  --w 3.5 --h 2.5 --lh 1.18 --cat Backend -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ROCKET_CASE_CACHE --out rocket_case_cache --w 0.9 --h 2.5 --lh 1.18 -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ROCKET_CASE_BRANCH --out rocket_case_branch --w 0.9 --h 2.5 --lh 1.18 -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ROCKET_CASE_CORE --out rocket_case_core --w 0.9 --h 2.5 --lh 1.18 -o $PC_DIR/iiswc-2025-ae-out/results/

tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ROCKET_CASE_CORE --out rocket_case_core --w 0.9 --h 2.5 --lh 1.18 --cat Backend -o $PC_DIR/iiswc-2025-ae-out/results/



# BOOM Plots
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_MICRO --out boom_micro --ipc --w 3.5 --h 2.5 --lh 1.18 -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_SPEC --out boom_spec --ipc --w 3.5 --h 2.5 --lh 1.18 -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_MICRO --out boom_micro --w 3.5 --h 2.5 --lh 1.18 --cat Backend -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_MICRO --out boom_micro --w 3.5 --h 2.5 --lh 1.18 --cat Frontend -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_MICRO --out boom_micro --w 3.5 --h 2.5 --lh 1.18 --cat BadSpeculation -o $PC_DIR/iiswc-2025-ae-out/results/

tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_SPEC --out boom_spec --w 3.5 --h 2.5 --lh 1.18 --cat Backend -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_SPEC --out boom_spec --w 3.5 --h 2.5 --lh 1.18 --cat Frontend -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_SPEC --out boom_spec --w 3.5 --h 2.5 --lh 1.18 --cat BadSpeculation -o $PC_DIR/iiswc-2025-ae-out/results/

tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_CASE_CORE --out boom_case_core --w 0.9 --h 2.5 --lh 1.18 --ipc -o $PC_DIR/iiswc-2025-ae-out/results/

tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_CASE_BRANCH --out boom_case_branch --w 0.9 --h 2.5 --lh 1.18 --ipc -o $PC_DIR/iiswc-2025-ae-out/results/


tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ --out total_all --w 5.5 --h 2.5 --lh 1.18 --cat Backend -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ --out total_all --w 5.5 --h 2.5 --lh 1.18 --cat Frontend --yl 0.1 -o $PC_DIR/iiswc-2025-ae-out/results/

tma_tool --plot-tma $DATA_DIR/FIRESIM_CASE_STUDIES/ --out case_all --ipc --w 5.5 --h 2.5 --lh 1.18 -o $PC_DIR/iiswc-2025-ae-out/results/

tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/ --out total_all --w 5.5 --h 2.5 --lh 1.18 --cat BadSpeculation -o $PC_DIR/iiswc-2025-ae-out/results/




# Run comparison plots
tma_tool --plot-count-diffs $DATA_DIR/FIRESIM_TOTAL_TMA/  -o $PC_DIR/iiswc-2025-ae-out/results/


tma_tool --compare-models $DATA_DIR/FIRESIM_TOTAL_TMA/ --out total_all --ipc --w 5.5 --h 2.5 --lh 1.18 --models BOOM_TMA BOOM_TMA_FETCH_APPROX   --cat Frontend > $PC_DIR/iiswc-2025-ae-out/results//compare_tma_fetch_approx.txt

tma_tool --compare-models $DATA_DIR/FIRESIM_TOTAL_TMA/ --out total_all --ipc --w 5.5 --h 2.5 --lh 1.18 --models BOOM_TMA BOOM_ISSUE_APPROX   --cat BadSpeculation > $PC_DIR/iiswc-2025-ae-out/results//compare_tma_issue_approx.txt

tma_tool --compare-models $DATA_DIR/FIRESIM_TOTAL_TMA/ --out total_all --ipc --w 5.5 --h 2.5 --lh 1.18 --models BOOM_TMA BOOM_RECOVER_APPROX   --cat BadSpeculation > $PC_DIR/iiswc-2025-ae-out/compare_tma_boom_approx.txt

# Show table of different per lane events
tma_tool --plot-count-diffs $DATA_DIR/FIRESIM_TOTAL_TMA/  > $PC_DIR/iiswc-2025-ae-out/results/table_5_per_lane_events.txt


# PLOT BOOM MICRO
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_MICRO --out micro --ipc --w 5.5 --h 2.5 --lh 1.18 -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_MICRO --out micro --w 5.5 --h 2.5 --lh 1.18 --cat Backend -o $PC_DIR/iiswc-2025-ae-out/results/
tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_MICRO --out micro --w 5.5 --h 2.5 --lh 1.18 --cat Frontend --yl 0.1 -o $PC_DIR/iiswc-2025-ae-out/results/

tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_MICRO --out micro --w 5.5 --h 2.5 --lh 1.18 --cat BadSpeculation -o $PC_DIR/iiswc-2025-ae-out/results/

tma_tool --plot-tma $DATA_DIR/FIRESIM_TOTAL_TMA/BOOM_MICRO --out micro --w 5.5 --h 2.5 --lh 1.18 --cat BranchMispredictions -o $PC_DIR/iiswc-2025-ae-out/results/

