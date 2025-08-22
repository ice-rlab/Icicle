#!/bin/bash

# destination folder name
DESIGN_NICKNAME="__DESIGN_CONFIG__"

# top-level module
DESIGN_NAME="__DESIGN_TOP__"

# destination platform(s)
DESIGN_PLATFORMS=(
  "asap7"
)

# root directory of design
DESIGN_SRC_PATH="__DESIGN_SRC_PATH__"

# glob path for RTL files relative to DESIGN_SRC_PATH
DESIGN_SRC_GLOB="*.*v"

# package files to include in SystemVerilog conversion
DESIGN_PKG_GLOB=""

# file names to exclude from destination
DESIGN_SRC_EXCLUSIONS_GLOB="Test*.*v"
DESIGN_SRC_EXCLUSIONS_REGEX="(Sim|ClockSourceAtFreqMHz)"

# paths to include directories for SystemVerilog header files (Format: '-Ipath/to/include/directory)
DESIGN_INCLUDE_DIRS=""

# specific define flags (Format: '--define=SYNTHESIS ...')
DESIGN_SYNTH_FLAGS="--define=SYNTHESIS --define=YOSYS"
