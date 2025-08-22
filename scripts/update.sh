#!/bin/bash

# Ensure a valid directory is provided
if [ -z "$1" ]; then
    echo "Please provide the directory path."
    exit 1
fi

# Iterate through all Scala files in the given directory
find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace all occurrences of UInt(n) with n.U
    sed -i -E 's/UInt\(([0-9]+)\)/\1.U/g' "$file"
    echo "Processed: $file"
done

# Iterate through all Scala files in the given directory
find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace all occurrences of Bool(OUTPUT) with Output(Bool())
    sed -i -E 's/Bool\(OUTPUT\)/Output\(Bool\(\)\)/g' "$file"
    echo "Processed: $file"
done


find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace all occurrences of x.flip with Flipped(x), ensuring proper handling of expressions
    sed -i -E 's/([A-Za-z0-9_]+\(.*\))\.flip/Flipped(\1)/g' "$file"
    echo "Processed: $file"
done

find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace all occurrences of UInt(number, width.W) with number.U(width.W)
    sed -i -E 's/UInt\(([0-9]+), ([0-9]+\.W)\)/\1.U(\2)/g' "$file"
    echo "Processed: $file"
done

# Iterate through all Scala files in the given directory
find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace all occurrences of UInt(OUTPUT, 64.W, ..., x, y, z) with Output(64.W, ..., x, y, z)
    sed -i -E 's/UInt\(OUTPUT, ([^,]+), ([^)]*)\)/Output\(\1, \2\)/g' "$file"
    echo "Processed: $file"
done


find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace all occurrences of UInt(OUTPUT, width.W) with Output(UInt(width.W))
    sed -i -E 's/UInt\(OUTPUT, ([^,]+\.W)\)/Output(UInt(\1))/g' "$file"
    echo "Processed: $file"
done

# Iterate through all Scala files in the given directory
find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace all occurrences of UInt(width=n) with UInt(n.W)
    sed -i -E 's/UInt\(width=([0-9]+)\)/UInt(\1.W)/g' "$file"
    echo "Processed: $file"
done


find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace Bool(false) with false.B
    sed -i -E 's/Bool\(false\)/false.B/g' "$file"
    
    # Use sed to replace Bool(true) with true.B
    sed -i -E 's/Bool\(true\)/true.B/g' "$file"
    
    echo "Processed: $file"
done

# Iterate through all Scala files in the given directory
find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace all occurrences of UInt(0x...) with 0x...U
    sed -i -E 's/UInt\(0x([0-9A-Fa-f]+)\)/0x\1.U/g' "$file"
    echo "Processed: $file"
done


# Iterate through all Scala files in the given directory
find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace Bool(INPUT) with Input(Bool())
    sed -i -E 's/Bool\(INPUT\)/Input\(Bool\(\)\)/g' "$file"
    
    # Use sed to replace UInt(INPUT, log2Up(16+1).W) with Input(UInt(log2Up(16+1).W))
    sed -i -E 's/UInt\(INPUT, (log2Up\([0-9\+]+\).W\))/Input\(UInt(\1\))/g' "$file"
    
    echo "Processed: $file"
done

echo "Replacement complete!"


# Iterate through all Scala files in the given directory
find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace UInt(VARIABLE_NAME) with VARIABLE_NAME.U
    sed -i -E 's/UInt\((\w+)\)/\1.U/g' "$file"
    echo "Processed: $file"
done


# Iterate through all Scala files in the given directory
find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace UInt(VARIABLE_NAME) with VARIABLE_NAME.U
    sed -i -E 's/UInt\((\w+)\)/\1.U/g' "$file"

    # Use sed to replace UInt(0, log2Up(...).W) with 0.U(log2Up(...).W)
    sed -i -E 's/UInt\(0, ([^)]+)\)/0.U(\1)/g' "$file"

    echo "Processed: $file"
done


find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace .fire() with .fire
    sed -i -E 's/\.fire\(\)/\.fire/g' "$file"
    echo "Processed: $file"
done





# Iterate through all Scala files in the given directory
find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace Bits(x) with x.U
    sed -i -E 's/Bits\(([^)]+)\)/\1.U/g' "$file"
    echo "Processed: $file"
done


find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace Vec.fill(x)(y) with VecInit(Seq.fill(x)(y))
    sed -i -E 's/Vec\.fill\(([0-9a-zA-Z_]+)\)\(([^)]+)\)/VecInit(Seq.fill(\1)(\2))/g' "$file"
    echo "Processed: $file"
done


find "$1" -type f -name "*.scala" | while read -r file; do
    # Use sed to replace import Chisel._ with the correct imports
    sed -i 's/import Chisel._/import chisel3._\nimport chisel3.util._/g' "$file"
    echo "Processed: $file"
done
