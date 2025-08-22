#!/bin/bash

configs=(MegaBoomV3Config MegaBoomScalarCountersConfig MegaBoomAddWiresConfig MegaBoomDistributedCountersConfig)

mkdir -p ${PC_DIR}/iiswc-2025-ae-out/vlsi

pushd ${PC_DIR}/vlsi
for config in "${configs[@]}"; do
  # create directory if does not already exist
  [ ! -d "$(make CONFIG=$config cd-locate)"] && make CONFIG=$config verilog cd-add

  # run to placement and report metrics for this configuration
  make CONFIG=$config cd-run_pnr-place cd-post-process
done

# aggregate metrics and print plots
make cd-report
make vlsi_plot

popd

set -x
ls ${PC_DIR}/iiswc-2025-ae-out/vlsi/*.svg
set +x
