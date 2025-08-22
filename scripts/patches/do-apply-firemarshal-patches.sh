#!/bin/bash
source $PC_DIR/scripts/patches/do-apply-patch.sh
apply_git_patch  platforms/chipyard/software/firemarshal scripts/patches/firemarshal-overlay-subfolder.patch
apply_git_patch  platforms/chipyard/software/firemarshal scripts/patches/firemarshal-nodisk-and-common.patch
