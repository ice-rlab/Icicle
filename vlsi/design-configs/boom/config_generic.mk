
export VERILOG_FILE_GLOB      = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v
#export VERILOG_FILES         = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION       = 40
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY_LB_ADDON = 0.20
export SYNTH_MEMORY_MAX_BITS  = 16384

#export DIE_AREA = 0 0 859 859
#export CORE_AREA = 2 2 857 857

export ENABLE_DPO = 0

export TNS_END_PERCENT        = 100

