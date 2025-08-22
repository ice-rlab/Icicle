# Default custom workload
ifeq ($(JSON),)
    JSON_CONFIG_PATH = $(FS_WL_DIR)/$*-workload/marshal-configs/$*.json
	MICRO_JSON_CONFIG_PATH = $(FS_WL_DIR)/microbenchmarks-workload/$*-workload/marshal-configs/$*.json
else
    JSON_CONFIG_PATH = $(FS_WL_DIR)/$*-workload/marshal-configs/$(JSON).json
	MICRO_JSON_CONFIG_PATH = $(FS_WL_DIR)/microbenchmarks-workload/$*-workload/marshal-configs/$(JSON).json
endif

ifeq ($(D),1)
    MARSHAL_FLAGS = -d
else
    MARSHAL_FLAGS =
endif

MARSHAL_FLAGS += $(QUIET_MARSHAL)



# These commands are necessary as some workloads only work for specific linux versions. We want to quickly reset and checkout linux versions.
linux-v57-apply:
	@echo "Setting linux version to 5.7 patch as NVDLA driver is obselete in 6+"
	bash $(PC_DIR)/scripts/init/init-linux-v57.sh apply

linux-v57-reset:
	@echo "Resetting linux version to default"
	bash $(PC_DIR)/scripts/init/init-linux-v57.sh remove

show-workloads:
	@find "$(FS_WL_DIR)" -maxdepth 5 -type f -name '*.json' -exec basename {} \;
# SPEC workload
VALID_SPEC_JSONS = \
    spec17-intrate-ref-seq \
    spec17-intrate-test-500 \
    spec17-intrate-test-531 \
    spec17-intrate-ref-531 \
    spec17-intrate-test-541 \
    spec17-intrate-ref-500 \
    spec17-intrate-ref-505 \
    spec17-intrate-ref-520 \
    spec17-intrate-ref-523 \
    spec17-intrate-ref-525 \
    spec17-intrate-ref-531 \
    spec17-intrate-ref-541 \
    spec17-intrate-ref-548 \
    spec17-intrate-ref-557 \
    spec17-intrate-test-520 \
    spec17-intrate-ref-520 \
    spec17-intrate-test-seq \
    spec17-intrate-test \
    spec17-intrate \
    spec17-intspeed-test-600 \
    spec17-intspeed-test \
    spec17-intspeed


SPEC_JSON_CONFIG_PATH = $(FS_WL_DIR)/spec2017-workload/marshal-configs/$(JSON).json

# Check that JSON is set and valid
spec-check:
	@if [ -z "$(JSON)" ]; then \
		echo "Error: JSON variable is not set."; \
		echo "Please set JSON to one of the following:"; \
		echo "$(VALID_SPEC_JSONS)" | tr ' ' '\n'; \
		exit 1; \
	fi; \
	if ! echo "$(VALID_SPEC_JSONS)" | tr ' ' '\n' | grep -qx "$(JSON)"; then \
		echo "Error: JSON '$(JSON)' is not a valid option."; \
		echo "Valid options are:"; \
		echo "$(VALID_SPEC_JSONS)" | tr ' ' '\n'; \
		exit 1; \
	fi


spec-workload-build: spec-check pmu_setup_sbi pmu_all
	$(QUIET) "Building $(JSON)"
	@mkdir -p $(FS_WL_DIR)/spec2017-workload/pmu/
	@cp -f $(PMU_DIR)/out/*  $(FS_WL_DIR)/spec2017-workload/pmu/
	marshal $(MARSHAL_FLAGS) build $(SPEC_JSON_CONFIG_PATH)


spec-workload-install: spec-check
	$(QUIET) "Install $(JSON)"
	marshal $(MARSHAL_FLAGS) install $(SPEC_JSON_CONFIG_PATH)

spec-workload: spec-workload-build spec-workload-install 
	$(QUIET) "$(JSON) build and install complete."

spec-workload-clean:
	marshal $(MARSHAL_FLAGS) clean $(SPEC_JSON_CONFIG_PATH)

%-micro-workload-build: pmu_setup_sbi pmu_all
	$(QUIET) "Building $(JSON)"
	marshal $(MARSHAL_FLAGS) build $(MICRO_JSON_CONFIG_PATH)

%-micro-workload-install:
	$(QUIET) "Install $(JSON)"
	marshal $(MARSHAL_FLAGS) install $(MICRO_JSON_CONFIG_PATH)

%-micro-workload: %-micro-workload-build %-micro-workload-install
	$(QUIET) "$(JSON) build and install complete."

%-micro-workload-clean:
	marshal $(MARSHAL_FLAGS) clean $(MICRO_JSON_CONFIG_PATH)

nvdla-%-raw-workload-build:
	$(QUIET) "Building $*-workload"
	marshal $(MARSHAL_FLAGS) build $(NVDLA_WL_DIR)/nvdla-$*.json

nvdla-%-raw-workload-install:
	$(QUIET) "Install $*-workload"
	marshal $(MARSHAL_FLAGS) install $(NVDLA_WL_DIR)/nvdla-$*.json

nvdla-%-raw-workload: nvdla-%-raw-workload-build nvdla-%-raw-workload-install
	$(QUIET) "$*-workload build and install complete."

nvdla-%-raw-workload-build-clean:
	marshal $(MARSHAL_FLAGS) clean $(NVDLA_WL_DIR)/nvdla-$*.json

# TODO: Fix PMU setup for NVDLA workloads...
nvdla-%-workload-build: nvdla-%-raw-workload-build
	@echo "TODO"
nvdla-%-workload-install: nvdla-%-raw-workload-install
	@echo "TODO"
nvdla-%-workload-clean: nvdla-%-raw-workload-clean
	@echo "TODO"
nvdla-%-workload: nvdla-%-raw-workload
	@echo "TODO"

# Commands to build and install a workload, including PMU harnesses
%-workload-build: pmu_setup_sbi pmu_all
	$(QUIET) "Building $*-workload"
	@if [ ! -f "$(JSON_CONFIG_PATH)" ]; then \
	  echo "$(JSON_CONFIG_PATH) not found."; \
	  exit 1; \
	fi
	mkdir -p $(FS_WL_DIR)/$*-workload/overlay/
	@cp -f $(PMU_DIR)/out/*  $(FS_WL_DIR)/$*-workload/overlay/
	marshal $(MARSHAL_FLAGS) build $(JSON_CONFIG_PATH)

%-workload-install:
	$(QUIET) "Install $*-workload"
	marshal $(MARSHAL_FLAGS) install $(JSON_CONFIG_PATH)

%-workload: %-workload-build %-workload-install
	$(QUIET) "$*-workload build and install complete."

%-workload-clean:
	marshal $(MARSHAL_FLAGS) clean $(JSON_CONFIG_PATH)

# Same as above, just without the PMU dependencies
%-raw-workload-build:
	$(QUIET) "Building $*-workload"
	mkdir -p $(FS_WL_DIR)/$*-workload/overlay/
	marshal $(MARSHAL_FLAGS) build $(JSON_CONFIG_PATH)

%-raw-workload-install:
	$(QUIET) "Install $*-workload"
	marshal $(MARSHAL_FLAGS) install $(JSON_CONFIG_PATH)

%-raw-workload: %-raw-workload-build %-raw-workload-install
	$(QUIET) "$*-workload build and install complete."

%-raw-workload-clean:
	marshal $(MARSHAL_FLAGS) clean $(JSON_CONFIG_PATH)
