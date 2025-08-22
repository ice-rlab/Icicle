TARGET = riscv64-unknown-elf
TARGET_LINUX = riscv64-unknown-linux-gnu

GCC = $(TARGET)-gcc
CXX = $(TARGET)-g++
GNU_GCC = $(TARGET_LINUX)-gcc
GNU_CXX = $(TARGET_LINUX)-g++
CP = $(TARGET)-objcopy
OBJDUMP = $(TARGET)-objdump
DG = $(TARGET)-gdb
SIZE = $(TARGET)-size


WFLAGS += -Wno-unused-variable -Wno-format
CFLAGS += -std=gnu99 -fno-common -fno-builtin-printf -Wall
LDFLAGS = -static



# Default values (can be overridden via command line)
COREWIDTH ?= 1
CORE ?= Unknown

SCALAR ?= 1

# Default issue widths of BOOM configurations
ifeq ($(CORE), Rocket)
  ISSUEWIDTH := 1
else ifeq ($(COREWIDTH),1)
  ISSUEWIDTH := 3
else ifeq ($(COREWIDTH),2)
  ISSUEWIDTH := 4
else ifeq ($(COREWIDTH),3)
  ISSUEWIDTH := 5
else ifeq ($(COREWIDTH),4)
  ISSUEWIDTH := 8
else ifeq ($(COREWIDTH),5)
  ISSUEWIDTH := 9
else
  $(error ISSUEWIDTH not set, unsupported COREWIDTH: $(COREWIDTH))
endif

CORE_FILE=core.h



# Evaluate D Flags
ifeq ($(CORE), Rocket)
  SBI_HPM_FILE := sbi_hpm_rocket.h
  CORE_NAME = ROCKET
else ifeq ($(CORE),Boom)
  SBI_HPM_FILE := sbi_hpm_boom.h
  CORE_NAME = BOOM
# else
#   $(error Unsupported CORE value: $(CORE))
endif


.PHONY: pmu_setup pmu_perf pmu_read_counters pmu_setup_sbi
#TODO: Setup BOOM SBI_hpm file...
pmu_all: pmu_perf pmu_read_counters

# Patches the sbi to hook into our hpm setup code.
.PHONY: pmu_setup
pmu_setup:
	mkdir -p $(PMU_DIR)/out/
	$(QUIET) "cd $(SBI_DIR) &&  git apply $(PC_DIR)/perf/pmu/sbi.patch > /dev/null 2>&1"
	@cd $(SBI_DIR) && git apply --check $(PC_DIR)/perf/pmu/sbi.patch >/dev/null 2>&1 && \
	git apply $(PC_DIR)/perf/pmu/sbi.patch || \
	echo "SBI patch already applied or not applicable."


pmu_perf: pmu_setup
	$(QUIET) "$(GNU_CXX) -O3  -D $(CORE_NAME)=1  -D COREWIDTH=$(COREWIDTH) $(PMU_DIR)/perf.cc -o $(PMU_DIR)/out/perf"
	# $(GNU_CXX) -O3 -D $(CORE_NAME)=1  -D COREWIDTH=$(COREWIDTH) $(PMU_DIR)/perf.cc -o $(PMU_DIR)/out/perf
	$(GNU_CXX) $(PMU_DIR)/perf.cc -o $(PMU_DIR)/out/perf

pmu_read_counters: setup
	$(QUIET) "$(GCC) $(CFLAGS) $(WFLAGS)  -D $(CORE_NAME)=1 -D COREWIDTH=$(COREWIDTH) $(PMU_DIR)/read_counters.c -o read_counters"
	# $(GCC)  $(CFLAGS) $(WFLAGS) -D $(CORE_NAME)=1 -D COREWIDTH=$(COREWIDTH) $(PMU_DIR)/read_counters.c -o $(PMU_DIR)/out/read_counters
	$(GCC)  $(CFLAGS) $(WFLAGS) $(PMU_DIR)/read_counters.c -o $(PMU_DIR)/out/read_counters

clean_core_h:
	rm -rf $(PMU_DIR)/core.h

pmu_setup_core_h:
	@if [ -z "$(SBI_HPM_FILE)" ]; then \
		echo "Error: SBI_HPM_FILE is not set. Did you forget to set CORE=<target-hardware>?"; \
		exit 1; \
	fi
	$(QUIET) "touch $(PMU_DIR)/core.h"
	touch $(PMU_DIR)/core.h
	$(QUIET) "Creating SBI symlinks: "
	$(QUIET) "ln -sf $(PMU_DIR)/$(SBI_HPM_FILE) $(SBI_INCL_DIR)/sbi_hpm.h"
	@ln -sf $(PMU_DIR)/$(SBI_HPM_FILE) $(SBI_INCL_DIR)/sbi_hpm.h
	@echo -e "#ifndef _CORE_H__\\n#define _CORE_H__\\n#define $(CORE_NAME)\\n#define COREWIDTH $(COREWIDTH)\\n#define ISSUEWIDTH $(ISSUEWIDTH)\\n#define SCALAR $(SCALAR)\\n#endif\\n" > $(PMU_DIR)/$(CORE_FILE)

# Hacky way to get counters running on firesim buildroot simulations
pmu_setup_sbi: pmu_setup_core_h
	$(QUIET) "ln -sf $(PMU_DIR)/tma_defs.h  $(SBI_INCL_DIR)/tma_defs.h"
	@ln -sf $(PMU_DIR)/tma_defs.h  $(SBI_INCL_DIR)/tma_defs.h
	$(QUIET) "ln -sf $(PMU_DIR)/core.h  $(SBI_INCL_DIR)/core.h"
	@ln -sf $(PMU_DIR)/core.h  $(SBI_INCL_DIR)/core.h

.PHONY: clean
pmu_clean:
	rm -rf $(PMU_DIR)/out/


# pmu_start_counters: setup
# 	$(QUIET) "$(GCC) $(CFLAGS) $(WFLAGS)  -D $(CORE_NAME)=1 -D COREWIDTH=$(COREWIDTH) $(PMU_DIR)/start_counters.c -o start_counters"
# 	$(GCC) $(CFLAGS) $(WFLAGS) -D $(CORE_NAME)=1 -D COREWIDTH=$(COREWIDTH) $(PMU_DIR)/start_counters.c -o $(PMU_DIR)/out/start_counters

# pmu_end_counters: setup
# 	$(QUIET) "$(GCC) $(CFLAGS) $(WFLAGS)  -D $(CORE_NAME)=1 -D COREWIDTH=$(COREWIDTH) $(PMU_DIR)/end_counters.c -o end_counters"
# 	$(GCC)  $(CFLAGS) $(WFLAGS) -D $(CORE_NAME)=1 -D COREWIDTH=$(COREWIDTH) $(PMU_DIR)/end_counters.c -o $(PMU_DIR)/out/end_counters