#!/bin/bash

# add oss-cad-suite bin to PATH
export PATH=__DOWNLOAD_DIR__/oss-cad-suite/bin:$PATH

# add sv2v to PATH
export PATH=__DOWNLOAD_DIR__/sv2v-Linux:$PATH

# export the path to the OpenROAD-flow-scripts repostiory
# cloned from https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
export OPENROAD_SCRIPTS=__DOWNLOAD_DIR__/OpenROAD-flow-scripts

# specific executables
export OPENROAD_EXE=$(command -v openroad)
export YOSYS_EXE=$(command -v yosys)
