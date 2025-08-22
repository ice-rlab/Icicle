BUILD_CONFIG = $(FS_CONFIG_DIR)/config_build.yaml
RUN_CONFIG = $(FS_CONFIG_DIR)/config_runtime.yaml
META_RUN_CONFIG = $(FS_CONFIG_DIR)/meta_config_runtime.yaml
HWDB_CONFIG = $(FS_CONFIG_DIR)/config_hwdb.yaml
REC_CONFIG = $(FS_CONFIG_DIR)/config_build_recipes.yaml

# simulator to use for metasimulations (verilator or vcs)
METASIM_SIM ?= verilator
# Enable metasimulation debug mode (1 = enabled, 0 = disabled)
META_DEBUG ?= 0

# Override defaults with command-line arguments
WORKLOAD ?=
HW ?=

# Trace output formats. Only enabled if "enable" is set to "yes" above
# 0 = human readable; 1 = binary (compressed raw data); 2 = flamegraph (stack
# unwinding -> Flame Graph)
TRACE_FORMAT ?= 1

# Trigger selector.
# 0 = no trigger; 1 = cycle count trigger; 2 = program counter trigger; 3 =
# instruction trigger
TRACE_TRIGGER ?= 3

TRACE_CUSTOM_WIDTH ?= 2
TRACE_CUSTOM ?= 1

ifeq ($(TRACE_CUSTOM),1)
  # All good — continue
else
  $(error TRACE_CUSTOM must be 1. Other configurations are not implemented.)
endif


TRACE_CYCLE_START ?= 10000
TRACE_CYCLE_END ?= 100000

TRACE_INSTR_TRIGGER_START ?= ffffffff00008013
TRACE_INSTR_TRIGGER_END ?= ffffffff00010013


FIRESIM_RUNS_DIR = ~/FIRESIM_RUNS_DIR

$(if $(filter 0 1 3,$(TRACE_TRIGGER)),,\
  $(error TRACE_TRIGGER must be 0, 1, or 3, got '$(TRACE_TRIGGER)'))


COMMON_SETUP := \
	$(if $(HW),-x="target_config default_hw_config $(HW)",) \
	$(if $(WORKLOAD),-x="workload workload_name $(WORKLOAD)",) \
	-x"run_farm default_simulation_dir $(FIRESIM_RUNS_DIR)"


# Remove past TRACE and metasim files to avoid constant copying over.
COMMON_PRECOMMANDS := rm -f $(FIRESIM_RUNS_DIR)/sim_slot_0/TRACE*; rm -f $(FIRESIM_RUNS_DIR)/sim_slot_0/*.vcd;


# Without custom trace driver, useful for debugging
# TRACE_COMMON_ARGS := \
# 	-x="tracing enable yes" \
# 	-x="tracing output_format $(TRACE_FORMAT)" \
# 	-x="target_config plusarg_passthrough +tracefile=TRACEFILE"

TRACE_COMMON_ARGS := \
	-x="tracing enable yes" \
	-x="tracing output_format $(TRACE_FORMAT)" \
	-x="target_config plusarg_passthrough +tracefile=TRACEFILE" \
	-x="target_config plusarg_passthrough +custom-trace" \
	-x="target_config plusarg_passthrough +custom-trace-width=$(TRACE_CUSTOM_WIDTH)"

TRACE_TRIGGER_ARGS := \
	-x="tracing selector $(TRACE_TRIGGER)" \
	$(if $(filter 0,$(TRACE_TRIGGER)), -x="tracing start 0" -x="tracing end -1",) \
	$(if $(filter 1,$(TRACE_TRIGGER)), -x="tracing start $(TRACE_CYCLE_START)" -x="tracing end $(TRACE_CYCLE_END)",) \
	$(if $(filter 3,$(TRACE_TRIGGER)), -x="tracing start $(TRACE_INSTR_TRIGGER_START)" -x="tracing end $(TRACE_INSTR_TRIGGER_END)",)

META_SIM_ARGS := \
$(if $(findstring 1,$(META_DEBUG)), \
    -x="metasimulation metasimulation_host_simulator $(METASIM_SIM)-debug", \
    -x="metasimulation metasimulation_host_simulator $(METASIM_SIM)")

.PHONY: managerinit infrasetup runworkload run buildbitstream run

init:
	cp $(FS_CONFIG_DIR)/templates/* $(FS_CONFIG_DIR)
	$(FS_DIR)/deploy/firesim  managerinit --platform xilinx_vcu118
pre:
	$(COMMON_PRECOMMANDS)

infrasetup: pre
	$(FS_DIR)/deploy/firesim \
	-b $(BUILD_CONFIG) -c $(RUN_CONFIG) \
	-r $(REC_CONFIG) -a $(HWDB_CONFIG) \
	infrasetup \
	$(COMMON_SETUP)

runworkload:
	$(FS_DIR)/deploy/firesim -b $(BUILD_CONFIG) -c $(RUN_CONFIG) \
	-r $(REC_CONFIG) -a $(HWDB_CONFIG) \
	runworkload \
	$(COMMON_SETUP)

run: infrasetup runworkload

infrasetup-trace: pre trace_decoder
	$(FS_DIR)/deploy/firesim \
	-b $(BUILD_CONFIG) -c $(RUN_CONFIG) \
	-r $(REC_CONFIG) -a $(HWDB_CONFIG) \
	infrasetup \
	$(COMMON_SETUP) \
	$(TRACE_TRIGGER_ARGS) \
	$(TRACE_COMMON_ARGS)

runworkload-trace:
	$(FS_DIR)/deploy/firesim -b $(BUILD_CONFIG) -c $(RUN_CONFIG) \
	-r $(REC_CONFIG) -a $(HWDB_CONFIG) \
	runworkload \
	$(COMMON_SETUP) \
	$(TRACE_TRIGGER_ARGS) \
	$(TRACE_COMMON_ARGS)

run-trace: infrasetup-trace runworkload-trace

meta-infrasetup: pre
	$(FS_DIR)/deploy/firesim \
	-b $(BUILD_CONFIG) -c $(META_RUN_CONFIG) \
	-r $(REC_CONFIG) -a $(HWDB_CONFIG) \
	infrasetup \
	$(COMMON_SETUP) \
	$(META_SIM_ARGS)

meta-runworkload:
	$(FS_DIR)/deploy/firesim -b $(BUILD_CONFIG) -c $(META_RUN_CONFIG) \
	-r $(REC_CONFIG) -a $(HWDB_CONFIG) \
	runworkload \
	$(COMMON_SETUP) \
	$(META_SIM_ARGS)

meta-run: meta-infrasetup meta-runworkload


meta-infrasetup-trace: pre trace_decoder
	$(FS_DIR)/deploy/firesim \
	-b $(BUILD_CONFIG) -c $(META_RUN_CONFIG) \
	-r $(REC_CONFIG) -a $(HWDB_CONFIG) \
	infrasetup \
	$(COMMON_SETUP) \
	$(META_SIM_ARGS) \
	$(TRACE_TRIGGER_ARGS) \
	$(TRACE_COMMON_ARGS)

meta-runworkload-trace:
	$(FS_DIR)/deploy/firesim -b $(BUILD_CONFIG) -c $(META_RUN_CONFIG) \
	-r $(REC_CONFIG) -a $(HWDB_CONFIG) \
	runworkload \
	$(COMMON_SETUP) \
	$(META_SIM_ARGS) \
	$(TRACE_TRIGGER_ARGS) \
	$(TRACE_COMMON_ARGS)

meta-run-trace: meta-infrasetup-trace meta-runworkload-trace

buildbitstream:
	$(FS_DIR)/deploy/firesim -b $(BUILD_CONFIG) -c $(RUN_CONFIG) \
	-r $(REC_CONFIG) -a $(HWDB_CONFIG) buildbitstream \
	$(if $(HW),-x="builds_to_run -$(HW)",) \
