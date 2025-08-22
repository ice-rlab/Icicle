#!/bin/bash

# Commit hashes
LINUX_57_BRANCH="nvdla-linux-v57"
OPENSBI_57_HASH="a98258d0b537a295f517bbc8d813007336731fa9"
OPENSBI_REVERT_HASH="5ccebf0a7ec79d0bbef36d6dcdc2717f25d40767"
ICENET_57_HASH="8d3589513981ee6b1176a4db8176dea8233ada20"
ICENET_REVERT_HASH="72022daf314ad45391e3b6398418c072091b51d1"
ICEBLK_57_HASH="7fdefc49bf242b55c389a32af98e4f1a46290ac1"
ICEBLK_REVERT_HASH="e2b1d25aef89601d52a70784401796a1d2845721"
BR_BASE_57_HASH="3ea64d0daedfb58c55585eadc79a26ee92b0254b"
LINUX_REVERT_HASH="67bc4513761f09952a5d5f5c899630ed91ce6442"
ICEBLK_DTS_COMMIT_HASH="d03bc6000a231a43dae7eb82a1dbec77b871244a"

# Usage: ./init-linux-v57.sh {apply|remove}

# error handling
handle_error() {
    echo "Error: $1" >&2
    exit 1
}

# Used to force checkout even if local changes are present. This is 
# somewhat hacky and can be dangerous, but is nice to have for 
# now for quick runs on NVDLA vs non-NVDLA workflows.
force_checkout() {
    target="$1"
    # Stash or reset local changes
    git reset --hard >/dev/null 2>&1
    git clean -fd >/dev/null 2>&1
    git fetch --all --quiet
    git checkout "$target" || handle_error "Failed to checkout $target"
}

apply_changes() {
    echo "Applying versions and patches for NVDLA..."

    # LINUX directory checkout
    echo "Checking out nvdla-linux-v57 in LINUX directory..."
    cd "$PC_DIR/platforms/chipyard/software/firemarshal/boards/default/linux" || handle_error "Failed to cd to LINUX directory"
    force_checkout "$LINUX_57_BRANCH" || handle_error "Failed to checkout in LINUX directory"

    # OpenSBI directory checkout
    echo "Checking out a98258d0b537a295f517bbc8d813007336731fa9 in openSBI directory..."
    cd "$PC_DIR/platforms/chipyard/software/firemarshal/boards/default/firmware/opensbi" || handle_error "Failed to cd to openSBI directory"
    force_checkout "$OPENSBI_57_HASH" || handle_error "Failed to checkout in openSBI directory"

    # ICENET directory checkout
    echo "Checking out 8d3589513981ee6b1176a4db8176dea8233ada20 in ICENET directory..."
    cd "$PC_DIR/platforms/chipyard/software/firemarshal/boards/firechip/drivers/icenet-driver" || handle_error "Failed to cd to ICENET directory"
    force_checkout "$ICENET_57_HASH" || handle_error "Failed to checkout in ICENET directory"

    # ICEBLK directory checkout
    echo "Checking out 7fdefc49bf242b55c389a32af98e4f1a46290ac1 in ICEBLK directory..."
    cd "$PC_DIR/platforms/chipyard/software/firemarshal/boards/firechip/drivers/iceblk-driver" || handle_error "Failed to cd to ICEBLK directory"
    force_checkout "$ICEBLK_57_HASH" || handle_error "Failed to checkout in ICEBLK directory"
    git cherry-pick "$ICEBLK_DTS_COMMIT_HASH" || handle_error "Failed to cherry-pick ICEBLK DTS commit"

    # base-workloads directory file checkouts
    echo "Checking out files in base-workloads directory..."
    cd "$PC_DIR/platforms/chipyard/software/firemarshal/boards/firechip/base-workloads/" || handle_error "Failed to cd to base-workloads directory"
    git checkout "$BR_BASE_57_HASH" -- br-base || handle_error "Failed to checkout br-base"
    git checkout "$BR_BASE_57_HASH" -- br-base.json || handle_error "Failed to checkout br-base.json"

    # Apply patches
    echo "Applying firemarshal-linux-v57 patches..."
    cd "$PC_DIR/scripts/patches" || handle_error "Failed to cd to patches directory"
    bash do-apply-linux-v57-patches.sh || handle_error "Failed to apply patches"

    echo "All checkouts and patches for NVDLA applied successfully."
}

remove_changes() {
    # Remove patches first using removal script
    echo "Removing firemarshal-linux-v57 patches..."
    cd "$PC_DIR/scripts/patches" || handle_error "Failed to cd to patches directory"
    bash do-remove-linux-v57-patches.sh || handle_error "Failed to remove patches"

    # Revert file checkouts in base-workloads directory
    echo "Reverting files in base-workloads directory..."
    cd "$PC_DIR/platforms/chipyard/software/firemarshal/boards/firechip/base-workloads/" || handle_error "Failed to cd to base-workloads directory"
    git checkout HEAD -- br-base br-base.json || handle_error "Failed to revert files in base-workloads directory"

    # Revert ICEBLK directory checkout
    echo "Reverting checkout in ICEBLK directory..."
    cd "$PC_DIR/platforms/chipyard/software/firemarshal/boards/firechip/drivers/iceblk-driver" || handle_error "Failed to cd to ICEBLK directory"
    force_checkout "$ICEBLK_REVERT_HASH" || handle_error "Failed to revert checkout in ICEBLK directory"

    # Revert ICENET directory checkout
    echo "Reverting checkout in ICENET directory..."
    cd "$PC_DIR/platforms/chipyard/software/firemarshal/boards/firechip/drivers/icenet-driver" || handle_error "Failed to cd to ICENET directory"
    force_checkout "$ICENET_REVERT_HASH" || handle_error "Failed to revert checkout in ICENET directory"

    # Revert openSBI directory checkout
    echo "Reverting checkout in openSBI directory..."
    cd "$PC_DIR/platforms/chipyard/software/firemarshal/boards/default/firmware/opensbi" || handle_error "Failed to cd to openSBI directory"
    force_checkout "$OPENSBI_REVERT_HASH" || handle_error "Failed to revert checkout in openSBI directory"

    # Revert LINUX directory checkout (fix at some point)
    echo "Reverting checkout in LINUX directory..."
    cd "$PC_DIR/platforms/chipyard/software/firemarshal/boards/default/linux" || handle_error "Failed to cd to LINUX directory"
    force_checkout "$LINUX_REVERT_HASH" || handle_error "Failed to revert checkout in LINUX directory"

    echo "All checkouts and patches for NVDLA removed successfully."
}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {apply|remove}"
    exit 1
fi

export PC_DIR

case "$1" in
    apply)
        apply_changes
        ;;
    remove)
        remove_changes
        ;;
    *)
        echo "Error: Invalid argument '$1'. Use 'apply' or 'remove'." >&2
        echo "Usage: $0 {apply|remove}" >&2
        exit 1
        ;;
esac

exit 0