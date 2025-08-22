
ifeq (,$(wildcard $(PC_DIR)/vlsi/Makefile))
	$(error Could not find variable $(PC_DIR), please source the env.sh script)
endif

# configuration variables
export TECH ?= asap7
export CONFIG ?= MegaBoomV3Config
export CONFIG_NICKNAME ?= $(CONFIG)
export CORE_TOP ?= BoomCore
export BENCHMARK ?= matrix_accum

SIM ?= verilator

# executables
CP ?= cp -rT
PYTHON ?= python3

# directory paths
CHIPYARD_ROOT ?= $(abspath ../platforms/chipyard/sims/$(SIM))
CHIPYARD_OUT = $(CHIPYARD_ROOT)/generated-src/chipyard.harness.TestHarness.$(CONFIG)/gen-collateral
BENCHMARKS ?= ../benchmarking/microbenchmarks/benchmarks

plug_files ?= $(wildcard ./plugs/*.mk)

.PHONY: help-header
help-header:
	@echo "VLSI flow Makefile"
	@echo "------------------"
	@echo "Set the following variables:"
	@echo "  TECH: physical technology, default is asap7."
	@echo "  CONFIG: Chipyard configuration to synthesize, default is MegaBoomV3Config."
	@echo "  CONFIG_NICKNAME: Shorter name to prevent command overflow, default is \$(CONFIG)."
	@echo "  CORE_TOP: Name of the top-level RTL module, default is BoomCore."
	@echo "------------------"

.PHONY: help-header
help: help-header $(addsuffix -help,$(notdir $(basename $(plug_files))))

###################################################
##### Generate Verilog code for the VLSI flow #####
###################################################

# produce Verilog output
verilog:
	# run chisel compiler
	+$(MAKE) CONFIG=$(CONFIG) -C $(CHIPYARD_ROOT) verilog
	# copy source file with source code
	$(CP) ./scripts/source_design.sh $(CHIPYARD_OUT)/source_design.sh
	@sed -i -e "s+__DESIGN_SRC_PATH__+$(CHIPYARD_OUT)+g" $(CHIPYARD_OUT)/source_design.sh
	@sed -i -e "s+__DESIGN_CONFIG__+$(CONFIG_NICKNAME)+g" $(CHIPYARD_OUT)/source_design.sh
	@sed -i -e "s+__DESIGN_TOP__+$(CORE_TOP)+g" $(CHIPYARD_OUT)/source_design.sh

# clean Verilog output
clean_verilog:
	+$(MAKE) CONFIG=$(CONFIG) -C $(CHIPYARD_ROOT) clean

##############################################
##### Synthesis and physical design flow #####
##############################################

-include $(plug_files)

#####################################
##### Post-synthesis simulation #####
#####################################

.PHONY: build-synth-sim
build-synth-sim:
	@bash ./scripts/build_synth_sim.sh $(CHIPYARD_OUT) $(TECH) $(CONFIG_NICKNAME) $(CORE_TOP)

	# build new verilator executable
	+$(MAKE) CONFIG=$(CONFIG) -C $(CHIPYARD_ROOT)

.PHONY: run-synth-sim
run-synth-sim:
	# this is failing because of assertions; maybe temporarily disable assertions in build command
	$(CHIPYARD_ROOT)/simulator-chipyard.harness-$(CONFIG) $(BENCHMARKS)/$(BENCHMARK).riscv

#.PHONY: copy-synth-saif
#copy-synth-saif:
#	# copy SAIF file
#	$(CP) $(CHIPYARD_ROOT)/simx.saif $(OPENROAD_SCRIPTS)/flow/designs/$(TECH)/$(CONFIG_NICKNAME)/simx.saif

#####################
##### Reporting #####
#####################

.PHONY: vlsi_plot
vlsi_plot:
	$(PYTHON) ./scripts/vlsi_plot.py $(PC_DIR)/iiswc-2025-ae-out/vlsi/stats.csv $(PC_DIR)/iiswc-2025-ae-out/vlsi/vlsi

###################
##### Cleanup #####
###################

.PHONY: clean
clean: clean_verilog clean_OpenROAD
