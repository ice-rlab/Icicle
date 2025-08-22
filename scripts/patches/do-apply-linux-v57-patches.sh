#!/bin/bash
source $PC_DIR/scripts/patches/do-apply-patch.sh
apply_git_patch  platforms/chipyard/software/firemarshal/boards/default/firmware/opensbi scripts/patches/opensbi.patch
apply_git_patch  platforms/chipyard/software/firemarshal/boards/default/linux scripts/patches/linux_v57.patch