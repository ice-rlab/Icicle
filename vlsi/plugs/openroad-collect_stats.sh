#!/bin/bash

now=$(date "+%Y_%m_%d-%H_%M_%S")
out_file=$(pwd)/stats-${now}.csv
metrics_filter=$(pwd)/metrics_filter.txt

[ ! -d ./OpenROAD_out/logs ] && echo "logs directory does not exist" && exit 1
pushd ./OpenROAD_out/logs

# write header
steps=("floorplan" "place" "cts" "globalroute")
echo -n "design.config,syn.area.total,syn.area.seq," > $out_file
for step in "${steps[@]}"; do
  #for key in "${keys[@]}"; do
  #  echo -n "${step}.${key}," >> $out_file
  #done
  while IFS= read -r line; do
    echo -n "${step}.${line%% *}," >> $out_file
  done < ${metrics_filter}
done
echo "" >> $out_file

function write_token {
  text=$1
  token_idx=$2

  ${file%%#*}

  echo "$text" | eval "awk '{ORS = \",\"}{print(\$${token_idx})}'" >> $out_file
}

function write_json_val {
  f=$1
  attr=$2

  line=$(grep "\"${attr}\"" ${f})
  #echo "Grep of $attr gets $line"
  if [ -z "$line" ]; then
    echo -n ',' >> $out_file
  else
    write_token "${line%%,*}" 2
  fi
}

function filter_metrics {
  f=$1
  prefix=$2
  if [ -f "$f" ]; then
    while IFS= read -r line; do
      write_json_val $f ${prefix}${line##* }
    done < ${metrics_filter}
  else
    while IFS= read -r line; do
      echo -n "," >> $f
    done < ${metrics_filter}
  fi
}

for dir in *; do
  [ ! -d $dir ] && continue

  echo "Directory is $dir"
  pushd ${dir}

  echo -n "${dir}," >> $out_file

  # synthesis statistics
  f="../../reports/${dir}/synth_stat.txt"
  if [ -f $f ]; then
    write_token "$(grep 'Chip area for module' $f)" 6
    write_token "$(grep 'used for sequential elements' $f)" 7
  else
    echo "Synthesis report not found at ${f}"
    echo -n ',,' >> $out_file
  fi

  filter_metrics "2_1_floorplan.json" "floorplan__"
  filter_metrics "3_5_place_dp.json" "detailedplace__"
  filter_metrics "4_1_cts.json" "cts__"
  filter_metrics "5_1_grt.json" "globalroute__"

  echo "" >> $out_file

  popd # ${dir}/base
done

popd # ./OpenROAD_out/logs
echo "Written to $out_file"
