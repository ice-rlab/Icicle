.PHONY: microbenchmarks
microbenchmarks:
	$(QUIET) "Running microbenchmarks: $(MICRO_DIR)"
	@cd $(MICRO_DIR) && make clean && make

riscv-tests:
	$(QUIET) "Running riscv-tests: $(RISCV_TEST_DIR)"
	@cd $(RISCV_TEST_DIR) && make clean && make
