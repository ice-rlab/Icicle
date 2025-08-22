#!/usr/bin/env bash

apply_git_patch() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: apply_git_patch <target_directory_relative_to_repo_root> <patch_file_relative_to_repo_root>"
    return 1 # Indicate an error
  fi
  
  local TARGET_DIR_RELATIVE="$1"
  local PATCH_FILE_RELATIVE="$2"

  local TARGET_DIR="${PC_DIR}/${TARGET_DIR_RELATIVE}"
  local PATCH_FILE="${PC_DIR}/${PATCH_FILE_RELATIVE}"

  local ORIGINAL_DIR=$(pwd)
  if [ ! -d "${TARGET_DIR}" ]; then
    echo "Error: Target directory not found: ${TARGET_DIR}"
    return 1
  fi
  if [ ! -f "${PATCH_FILE}" ]; then
    echo "Error: Patch file not found: ${PATCH_FILE}"
    return 1
  fi

  cd "${TARGET_DIR}"
  git apply --stat "${PATCH_FILE}"
  git apply "${PATCH_FILE}"

  # Check if the patch application was successful
  if [ $? -eq 0 ]; then
    echo "Patch applied successfully."
  else
    echo "Error applying patch."
  fi

  cd "${ORIGINAL_DIR}"
  return 0 # Indicate success
}

# Example of how to call the function if this script is executed directly
if [ "${0##*/}" == "${BASH_SOURCE##*/}" ]; then
  if [ "$#" -ne 2 ]; then
    echo "Usage: $(basename "$0") <target_directory_relative_to_repo_root> <patch_file_relative_to_repo_root>"
    exit 1
  fi
  apply_git_patch "$1" "$2"
fi
