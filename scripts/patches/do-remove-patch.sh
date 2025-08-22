#!/usr/bin/env bash
# This script provides a function to remove a git patch from a target directory.

remove_git_patch() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: remove_git_patch <target_directory_relative_to_repo_root> <patch_file_relative_to_repo_root>"
    return 1
  fi

  local TARGET_DIR_RELATIVE="$1"
  local PATCH_FILE_RELATIVE="$2"

  # PC_DIR is expected to be an environment variable set by the main script.
  if [ -z "$PC_DIR" ]; then
    echo "Error: PC_DIR environment variable is not set."
    return 1
  fi

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

  echo "Changing to directory: ${TARGET_DIR}"
  cd "${TARGET_DIR}"

  git apply --reverse "${PATCH_FILE}"

  if [ $? -eq 0 ]; then
    echo "Patch removed successfully from ${TARGET_DIR_RELATIVE}."
  else
    echo "Error removing patch from ${TARGET_DIR_RELATIVE}. You may need to reset manually (e.g., git checkout -- .)."
  fi

  cd "${ORIGINAL_DIR}"
  return 0
}

# Allow direct execution for testing or manual use
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if [ "$#" -ne 2 ]; then
    echo "Usage: $(basename "$0") <target_directory_relative_to_repo_root> <patch_file_relative_to_repo_root>"
    exit 1
  fi
  # For direct execution, you must set PC_DIR manually, e.g.:
  # export PC_DIR=~/riscv-performance-characterization
  if [ -z "$PC_DIR" ]; then
     echo "Error: PC_DIR environment variable must be set to the repository root."
     exit 1
  fi
  remove_git_patch "$1" "$2"
fi