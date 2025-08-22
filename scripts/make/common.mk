CY_DIR = $(PC_DIR)/platforms/chipyard
FS_DIR = $(PC_DIR)/platforms/chipyard/sims/firesim
FM_DIR = $(PC_DIR)/platforms/chipyard/software/firemarshal
FS_WL_DIR = $(PC_DIR)/sims/firesim-workloads
FS_SCRIPTS = $(PC_DIR)/scripts/firesim
PMU_DIR = $(PC_DIR)/perf/pmu/

VER_DIR = $(CY_DIR)/sims/verilator
VCS_DIR = $(CY_DIR)/sims/vcs

NVDLA_WL_DIR = $(PC_DIR)/sims/firesim-workloads/nvdla-workload/marshal-configs/

TD_DIR = $(PC_DIR)/sims/firesim-trace



BENCH_DIR = $(PC_DIR)/benchmarking/
MICRO_DIR =  $(BENCH_DIR)/microbenchmarks/benchmarks
RISCV_TEST_DIR =  $(BENCH_DIR)/microbenchmarks/riscv-tests/benchmarks


SBI_DIR = $(FM_DIR)/boards/default/firmware/opensbi/
SBI_INCL_DIR = $(SBI_DIR)/include/sbi/

FS_CONFIG_DIR = $(PC_DIR)/sims/firesim-configs

DATE     := $(shell date +%Y-%m-%d)
TIME     := $(shell date +%H:%M:%S)
HOUR     := $(shell date +%H)
DATETIME := $(shell date +%Y-%m-%d_%H-%M-%S)

SHELL := /bin/bash

.PHONY:
all: help

ifeq ($(V), 2)
    QUIET_MARSHAL = -v
    QUIET = @echo
else ifeq ($(V), 1)
    QUIET_MARSHAL = 
    QUIET = @echo
else
    QUIET_MARSHAL = 
    QUIET = @true  # No echoing unless verbose is set
endif
