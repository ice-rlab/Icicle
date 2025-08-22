
# Environment setup

To download all the tools, run `setup.sh` from the directory where you want to download.

```
cd /path/to/tools/root
/path/to/riscv-pmu-core/vlsi/setup.sh
```

Make sure this succeeds by trying to run the installed tools. There may be some versioning issues, so you can modify the links to download for your appropriate machine.

# Running instructions

Run any of the targets in the Makefile. To run with the extended set of counters, set the make variable as shown below. You must source the generated source_vlsi.sh script first (which `setup.sh` created).

```
# set the variable in the call to make
source /path/to/tools/root/source_vlsi.sh
make ROCKET_VERSION=<rocket_base|rocket_topdown> verilog openroad clean_all synth do-synth-report floorplan place cts route final

# OR by environment variable
source /path/to/tools/root/source_vlsi.sh
export ROCKET_VERSION=<rocket_base|rocket_topdown>
make verilog openroad clean_all synth do-synth-report floorplan place cts route final
```

* `verilog`: Generate the SystemVerilog code from the Chisel description of Rocket.
* `openroad`: Copy the generated SystemVerilog code (after converting to Verilog) to the OpenROAD flow directory.
* `clean_all`, `synth`, `do-synth-report`, `floorplan`, `place`, `cts`, `route`, `final`: Various targets for the OpenROAD Makefile.

# Reporting instructions

To grab the reports from OpenROAD directly, there is a make target, `OpenROAD_out`, which copies the logs, reports, and results from each run of the flow. Run it like the above make targets.

```
make ROCKET_VERSION=<rocket_base|rocket_topdown> OpenROAD_out
```
