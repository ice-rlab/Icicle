#!/usr/bin/env bash
echo "Top level: $PC_DIR"

# Main chipyard setup
git submodule update --init $PC_DIR/platforms/chipyard

# Benchmarks
git submodule update --init $PC_DIR/benchmarking/libgloss-htif
git submodule update --init --recursive $PC_DIR/benchmarking/coremark
git submodule update --init --recursive $PC_DIR/benchmarking/microbenchmarks/riscv-tests


git submodule update --init --recursive $PC_DIR/sims/firesim-workloads/spec2017-workload
git submodule update --init --recursive $PC_DIR/sims/firesim-workloads/coremark-workload
git submodule update --init --recursive $PC_DIR/sims/firesim-workloads/nvdla-workload


# Firesim drivers
git submodule update --init --recursive $PC_DIR/sims/firesim-drivers/dma_ip_drivers
git submodule update --init --recursive $PC_DIR/sims/firesim-drivers/dma_ip_drivers_xvsec

# FireSim prebuilt bitstreams
git submodule update --init $PC_DIR/sims/firesim-bitstream

# git submodule update --init --recursive $PC_DIR/platforms/chipyard/generators/compress-acc/

# Sometimes ibex does not get pulled?
cd $PC_DIR/platforms/chipyard/generators
git submodule update --init --recursive ibex/