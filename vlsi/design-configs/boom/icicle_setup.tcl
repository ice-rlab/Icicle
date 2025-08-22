# Please overwrite this file using the riscv-performance-characterization vlsi Make targets

# RTL settings
set TOPCELL          "BoomCore"
set clk_period       5000
set clk_name         "core_clock"
set clk_port_name    "clock"

# power breakdown parameters
set vcd_file "~/mergesort-SmallBoomV3Config.vcd"
set vcd_scope "TestDriver/testHarness/chiptop0/system/tile_prci_domain/element_reset_domain_boom_tile/core"
set vcd_start_time "777.7"
set power_breakdown_group [list memExeUnit alu_exe_unit FpPipeline decode_units_0 dec_brmask_logic rename_stage fp_rename_stage mem_issue_unit int_issue_unit dispatcher iregfile ll_wbarb iregister_read rob csr ftq_arb]
