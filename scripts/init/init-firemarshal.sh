#!/usr/bin/env bash
PC_DIR=$(git rev-parse --show-toplevel)
bash $PC_DIR/scripts/patches/do-apply-firemarshal-patches.sh