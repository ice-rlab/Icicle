
ifneq (,$(wildcard $(OPENROAD_SCRIPTS)/build_openroad.sh))

# copy Verilog design to the OpenROAD directory
or-add:
	@bash ./scripts/add_design.sh $(CHIPYARD_OUT)/source_design.sh $(OPENROAD_SCRIPTS)/flow/designs/src/$(CONFIG_NICKNAME) $(OPENROAD_SCRIPTS)/flow/designs/$(TECH)/$(DESIGN_NICKNAME) $(TECH)


#################################
##### Run OpenROAD commands #####
#################################

openroad-help:
	@echo "Use the following make targets to run the OpenROAD flow:"
	@echo "    or-clean: Clean the OpenROAD directory"
	@echo "    or-synth: Run logic synthesis"
	@echo "    or-do-synth-report: Run reporting after logic synthesis"
	@echo "    or-floorplan: Run floorplanning"
	@echo "    or-place: Run placement"
	@echo "    or-cts: Run clock tree synthesis"
	@echo "    or-grt: Run global routing"
	@echo "    or-route: Run routing"
	@echo "    or-final: Run final checks to produce GDSII outputs"
	@echo "    or-out: Collect products from the run"
	@echo "    or-report: Generate a csv file with all the statistics"

or-clean:
	$(MAKE) -C $(OPENROAD_SCRIPTS)/flow DESIGN_CONFIG=designs/$(TECH)/$(CONFIG_NICKNAME)/config.mk clean_all

or-%:
	$(MAKE) -C $(OPENROAD_SCRIPTS)/flow DESIGN_CONFIG=designs/$(TECH)/$(CONFIG_NICKNAME)/config.mk $*

#####################
##### Reporting #####
#####################

.PHONY: or-out
or-out:
	mkdir -p ./OpenROAD_out
	mkdir -p ./OpenROAD_out/logs
	rm -rf ./OpenROAD_out/logs/$(CONFIG)/
	$(CP) $(OPENROAD_SCRIPTS)/flow/logs/$(TECH)/$(CONFIG_NICKNAME)/base ./OpenROAD_out/logs/$(CONFIG)/
	mkdir -p ./OpenROAD_out/reports
	rm -rf ./OpenROAD_out/reports/$(CONFIG)/
	$(CP) $(OPENROAD_SCRIPTS)/flow/reports/$(TECH)/$(CONFIG_NICKNAME)/base ./OpenROAD_out/reports/$(CONFIG)/
	mkdir -p ./OpenROAD_out/results
	rm -rf ./OpenROAD_out/results/$(CONFIG)/
	$(CP) $(OPENROAD_SCRIPTS)/flow/results/$(TECH)/$(CONFIG_NICKNAME)/base ./OpenROAD_out/results/$(CONFIG)/

.PHONY: or-report
or-report:
	@bash ./scripts/collect_stats.sh openroad

else
or-help:
	@echo "Skipping openroad flow because variable OPENROAD_SCRIPTS [$(OPENROAD_SCRIPTS)] is not valid"

or-%:
	$(error OPENROAD_SCRIPTS [$(OPENROAD_SCRIPTS)] is not present. \
				Please update the variable OPENROAD_SCRIPTS. \
				Hint: run ./setup.sh then source the source_vlsi.sh \
				script in its destination)

endif
