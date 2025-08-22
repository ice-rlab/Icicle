#!/bin/bash

set -e
make clean

OUTFILE1="generated_miss_1.h"
OUTFILE2="generated_miss_2.h"

N=100

echo "// Auto-generated MISS calls" > "$OUTFILE1"
echo "// Auto-generated MISS calls" > "$OUTFILE2"

for ((i=1; i<=N; i++)); do
    echo "    MISS($i)" >> "$OUTFILE1"
done

for ((i=N+1; i<=2*N; i++)); do
    echo "    MISS($i)" >> "$OUTFILE2"
done

make
echo "Successfully built!"
