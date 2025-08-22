#!/bin/bash
source $PC_DIR/scripts/patches/do-remove-patch.sh
remove_git_patch platforms/chipyard/software/firemarshal/boards/default/firmware/opensbi scripts/patches/opensbi.patch
remove_git_patch platforms/chipyard/software/firemarshal/boards/default/linux scripts/patches/linux_v57.patch