#!/bin/bash

# Helper functions to find the last experiment directories
last_exp() {
    local latest_dir
    latest_dir=$(ls -1dt "$RESULTS_DIR"/*/ 2>/dev/null | head -n 1)
    if [ -z "$latest_dir" ]; then
        echo "No experiment directories found in $RESULTS_DIR"
        return 1
    fi
    echo "$latest_dir"
}

last_trace() {
    local last_exp_dir
    local last_decoded_trace
    last_exp_dir=$(last_exp) || return 1
    last_decoded_trace=$(find $last_exp_dir -type f -name "*.decoded") 
    echo $last_decoded_trace
}
