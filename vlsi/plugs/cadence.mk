
CD_ROOT_DIR ?= $(HOME)/cu-adam-flows
CD_DIR ?= cu-adam-flow-$(CONFIG_NICKNAME)
CD_DEST = $(abspath $(CD_ROOT_DIR)/$(CD_DIR))
CD_STEP ?= place

.PHONY: cadence-help
cadence-help:
	@echo "Use the following make targets to run the Cadence flow:"
	@echo "    cd-clean: Clean the Cadence results"
	@echo "    cd-run_synth: Run logic synthesis"
	@echo "    cd-run_pnr-floorplan: Run floorplanning"
	@echo "    cd-run_pnr-place: Run placement"
	@echo "    cd-run_pnr-cts: Run clock tree synthesis"
	@echo "    cd-run_pnr-route: Run routing"
	@echo "    cd-report: Report statistics from all configurations"

.PHONY: cd-add
cd-add:
	@mkdir -p $(CD_ROOT_DIR); \
	[ ! -d $(CD_DEST) ] && git clone git\@github.com:ice-rlab/cu-adam-flow.git $(CD_DEST); \
		pushd $(CD_DEST); git pull --force; popd; \
		mkdir -p $(CD_DEST)/input/plugs/innovus; \
		ln -sf $(PC_DIR)/vlsi/scripts/post_process.tcl $(CD_DEST)/input/plugs/innovus/$(CORE_TOP).place_post.tcl; \
		$(CP) $(PC_DIR)/vlsi/plugs/cadence-metrics_filter.txt $(CD_DEST)/input/metrics/metrics_filter.txt
		$(CP) $(DESIGN_CONFIG_SRC)/constraint.sdc $(CD_DEST)/input/SDC/$(CORE_TOP).sdc; \
		$(CP) $(DESIGN_CONFIG_SRC)/icicle_setup.tcl $(CD_DEST)/input/icicle_setup.tcl; \
		bash ./scripts/add_design.sh $(CHIPYARD_OUT)/source_design.sh $(CD_DEST)/input/RTL;

.PHONY: cd-post-process
cd-post-process:
	$(MAKE) -C $(CD_DEST) PNR_SCRIPT=$(PC_DIR)/vlsi/scripts/post_process.tcl run_pnr-script

.PHONY: cd-report
cd-report:
	@bash ./scripts/collect_stats.sh cadence $(CD_ROOT_DIR) $(CD_STEP) ./data/stats.csv

cd-%:
	$(MAKE) -C $(CD_DEST) $*
