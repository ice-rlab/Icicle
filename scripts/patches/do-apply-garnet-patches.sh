#!/bin/bash
source $PC_DIR/scripts/patches/do-apply-patch.sh
apply_git_patch  platforms/chipyard/sims/firesim/platforms/xilinx_vcu118/garnet-firesim/ scripts/patches/xilinx_vcu118_garnet-firesim.patch