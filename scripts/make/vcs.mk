# set RTL path from tile to core top
ifeq ($(CORE),Rocket)
    TILE_TO_CORE ?= .element_reset_domain_rockettile
endif
ifeq ($(CORE),Boom)
    TILE_TO_CORE ?= .element_reset_domain_boom_tile
endif

TILE_TO_TOP = $(TILE_TO_CORE)$(CORE_TO_TOP)

.PHONY:
vcs-build-%:
	$(QUIET) "Building $* vcs in $(VCS_DIR)"
	$(MAKE) -C $(VCS_DIR) CONFIG=$* DUMP_SCOPE=testHarness.chiptop0.system.tile_prci_domain$(TILE_TO_TOP) USE_VPD=1 $(VCS_DIR)/simv-chipyard.harness-$*-debug

.PHONY:
vcs-run-%:
	mkdir -p $(PC_DIR)/out/benchmarks
	@sim=$*; \
	vcs=$${sim%-micro-*}; \
	bench=$${bench:=$${sim#*-micro-}}; \
	echo "Simulator: $$vcs, Benchmark: $$bench"; \
	$(MAKE) -C $(VCS_DIR) CONFIG=$* USE_VPD=1 BINARY=$(MICRO_DIR)/$$bench.riscv run-binary-debug -o debug | tee $(PC_DIR)/out/benchmarks/$$vcs-$$bench-$(DATETIME).txt
