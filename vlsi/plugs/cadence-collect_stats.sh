#!/bin/bash

CD_ROOT_DIR=$1
CD_STEP=$2
CD_STEP="${CD_STEP:=place}"
OUT_FILE=$(realpath $3)

[ ! -d $CD_ROOT_DIR ] && echo "Could not find root directory for Cadence runs" && exit 1

echo "Configuration,area,density,instances,power,wirelength,csr_wirelength,csr_max_length_net,longest_csr_path" > $OUT_FILE

pushd $CD_ROOT_DIR
for d in ./cu-adam-flow-*; do
    pushd $d
    
    bash ./get_metrics.sh $CD_STEP

    config="${d##*cu-adam-flow-}"
    metrics="$(grep 'BoomCore' ./metrics/metrics.csv)"
    metrics="${metrics##BoomCore}"
    
    echo "${config}${metrics}" >> $OUT_FILE
    
    popd # $d
done
popd # $CD_ROOT_DIR

