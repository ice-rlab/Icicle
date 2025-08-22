# Top-level performance characterization directory
export PC_DIR=$(git rev-parse --show-toplevel)
export CY_DIR="$PC_DIR/platforms/chipyard"
export FS_DIR="$CY_DIR/sims/firesim/"
export RESULTS_DIR=$FS_DIR/deploy/results-workload/

source $PC_DIR/platforms/chipyard/env.sh

export PATH=$PATH:$PC_DIR/scripts/patches/
export PATH=$PATH:$PC_DIR/scripts/firesim/
export PATH=$PATH:$PC_DIR/scripts/experimental/

export PATH=$FS_DIR/utils/fireperf:$FS_DIR/utils/fireperf/FlameGraph:$PATH
# flag for scripts to check that this has been sourced
export FIRESIM_SOURCED=1
unamestr=$(uname)
RDIR=$FS_DIR
AWSFPGA=$RDIR/platforms/f1/aws-fpga
export CL_DIR=$AWSFPGA/hdk/cl/developer_designs/cl_firesim

export PATH=$PATH:$FS_DIR/deploy
export PATH=$PATH:$PC_DIR/plotting/
export PATH=$PATH:$PC_DIR/sims/firesim-trace/
export PATH=$PATH:$PC_DIR/scripts/experimental/
export PATH=$PATH:$PC_DIR/perf/tma/

source $PC_DIR/scripts/env/util.sh