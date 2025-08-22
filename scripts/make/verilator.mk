.PHONY:
verilator-build-%:
	$(QUIET) "Building $* verilator in $(VER_DIR)"
	@cd $(VER_DIR) && make CONFIG=$*

.PHONY:
verilator-run-%: 
	mkdir -p $(PC_DIR)/out/benchmarks
	@sim=$*; \
	verilator=$${sim%-micro-*}; \
	bench=$${sim#*-micro-}; \
	echo "Simulator: $$verilator, Benchmark: $$bench"; \
	$(VER_DIR)/simulator-chipyard.harness-$$verilator $(MICRO_DIR)/$$bench.riscv | tee $(PC_DIR)/out/benchmarks/$$verilator-$$bench-$(DATETIME).txt