#!/bin/bash

set -o pipefail

# initialize statistics table
now=`date "+%Y_%m_%d-%H_%M_%S"`
out_table=list-${now}-runs.csv
echo "Configuration,ConfigurationSC,Log,Status" > $out_table

# run one configuration
function do_make {
  # configuration variables
  local_now=`date "+%Y_%m_%d-%H_%M_%S"`
  log_file=out-${local_now}-${1}Boom${3}Config-pnr.txt
  config=${1}Boom${3}Config
  config_nickname=${2}_${4}

  # determine whether to skip
  code="skipped"
  eval "[ -z \${skip_${config}} ] && [ -z \${skip_${1}} ] && [ -z \${skip_${3}} ] && code=''"

  # run job
  if [ -z "$code" ]; then
    echo "Writing $config output to $log_file"
    openroad_steps=${openroad_steps:="verilog openroad clean_OpenROAD synth do-synth-report floorplan place cts"}
    (make CONFIG=${config} CONFIG_NICKNAME=${config_nickname} $openroad_steps OpenROAD_out |& tee $log_file) &> /dev/null
    code=$?
  fi

  # TODO parse statistics

  # write statistics
  echo "${config},${config_nickname},${log_file},${code}" >> $out_table
}

# run all configurations
if [ $# -eq 0 ]; then

  do_make Small sm V3 base
  do_make Small sm ScalarCounters scalar
  do_make Small sm AddWires add
  do_make Small sm DistributedCounters distr

  do_make Medium md V3 base
  do_make Medium md ScalarCounters scalar
  do_make Medium md AddWires add
  do_make Medium md DistributedCounters distr

  do_make Large lg V3 base
  do_make Large lg ScalarCounters scalar
  do_make Large lg AddWires add
  do_make Large lg DistributedCounters distr

  do_make Mega mg V3 base
  do_make Mega mg ScalarCounters scalar
  do_make Mega mg AddWires add
  do_make Mega mg DistributedCounters distr

  do_make Giga gg V3 base
  do_make Giga gg ScalarCounters scalar
  do_make Giga gg AddWires add
  do_make Giga gg DistributedCounters distr

# run specific configurations
else

  # scan through script arguments
  while [ $# -gt 3 ]; do
    echo Args are: $1 $2 $3 $4

    # run configuration
    do_make $1 $2 $3 $4

    # move to next configuration
    shift 4
  done

fi

echo "All done!"
