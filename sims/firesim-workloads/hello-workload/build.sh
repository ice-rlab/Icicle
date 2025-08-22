#!/bin/bash

set -e

echo "Building Hello.riscv"

mkdir -p overlay/
riscv64-unknown-linux-gnu-gcc -O0 hello.c -o overlay/hello.riscv

echo "Successfully built hello.riscv!"
