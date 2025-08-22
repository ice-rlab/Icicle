#!/usr/bin/env bash
export PC_DIR=$(git rev-parse --show-toplevel)


# Default to run everything
SKIP_SUBMODULES=false
SKIP_CHIPYARD=false
SKIP_FPGA=false
SKIP_FIRESIM=false
SKIP_FIREMARSHAL=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --skip=chipyard)
      SKIP_CHIPYARD=true
      ;;
    --skip=submodules)
      SKIP_SUBMODULES=true
      ;;
    --skip=firesim)
      SKIP_FIRESIM=true
      ;;
    --skip=firemarshal)
      SKIP_FIRESIM=true
      ;;
    --skip=fpga)
      SKIP_FPGA=true
      ;;
    *)
      echo "Unknown option: $arg"
      exit 1
      ;;
  esac
done

if ! $SKIP_SUBMODULES; then
  echo "Initializing submodules..."
  bash $PC_DIR/scripts/init/init-submodules.sh
  if [ $? -ne 0 ]; then
      echo "Failed to initialize submodules."
      exit 1
  fi
fi

if ! $SKIP_CHIPYARD; then
  echo "Running chipyard setup..."
  bash $PC_DIR/scripts/init/init-chipyard.sh
  if [ $? -ne 0 ]; then
      echo "Failed to initialize chipyard."
      exit 1
  fi
fi

if ! $SKIP_FIRESIM; then
  echo "Setting up FireSim environment..."
  bash $PC_DIR/scripts/init/init-firesim.sh
  if [ $? -ne 0 ]; then
      echo "Failed to initialize firesim."
      exit 1
  fi
fi

if ! $SKIP_FIREMARSHAL; then
  echo "Setting up FireMarshal environment..."
  bash $PC_DIR/scripts/init/init-firemarshal.sh
  if [ $? -ne 0 ]; then
      echo "Failed to initialize firemarshal."
      exit 1
  fi
fi

if ! $SKIP_FPGA; then
  echo "Setting up FPGA environment..."
  bash $PC_DIR/scripts/init/init-fpga.sh
  if [ $? -ne 0 ]; then
      echo "Failed to initialize fpga setup."
      exit 1
  fi
fi

echo "Init completed."






