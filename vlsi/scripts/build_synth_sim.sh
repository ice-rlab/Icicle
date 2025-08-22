#!/bin/bash

CHIPYARD_OUT=$1
TECH=$2
CONFIG_NICKNAME=$3
CORE_TOP=$4

pushd ${CHIPYARD_OUT}/../

# create filelist backup
if [ ! -f sim_files.common.f.bak ] ; then
  cp sim_files.common.f sim_files.common.f.bak
fi

echo "" > sim_files.common.f

# add PDK files
if [ "${TECH}" = "asap7" ]; then
  find ${OPENROAD_SCRIPTS}/flow/platforms/${TECH}/work_around_yosys -name "*.v" >> sim_files.common.f
else
  find ${OPENROAD_SCRIPTS}/flow/platforms/${TECH}/verilog -name "*.v" >> sim_files.common.f
fi

# add synthesized core
#flow/results/asap7/mg_add/base/1_synth.v
echo "${OPENROAD_SCRIPTS}/flow/results/${TECH}/${CONFIG_NICKNAME}/base/1_synth.v" >> sim_files.common.f

# add all other files
grep --invert-match "${CORE_TOP}.sv" sim_files.common.f.bak >> sim_files.common.f

popd # ${CHIPYARD_OUT}/../
