#!/usr/bin/env bash
export PC_DIR=$(git rev-parse --show-toplevel)

cd $PC_DIR/platforms/chipyard
bash build-setup.sh
