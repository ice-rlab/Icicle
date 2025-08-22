#!/bin/bash

make CONFIG=MegaBoomV3Config cd-post-process
make CONFIG=MegaBoomScalarCountersConfig cd-post-process
make CONFIG=MegaBoomAddWiresConfig cd-post-process
make CONFIG=MegaBoomDistributedCountersConfig cd-post-process
make cd-report
make vlsi_plot
