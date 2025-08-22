#!/bin/bash

set -e

echo "Building Mergesort.riscv"

mkdir -p overlay/
riscv64-unknown-linux-gnu-gcc -O2 mergesort.c -o overlay/mergesort.riscv

echo "Successfully built mergesort.riscv!"
