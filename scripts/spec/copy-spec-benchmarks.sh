#!/bin/bash

# Check if SPEC_DIR environment variable is set
if [ -z "$SPEC_DIR" ]; then
  echo "Error: SPEC_DIR environment variable is not set."
  echo "Please set it to the root directory of your SPEC CPU benchmark installation."
  exit 1
fi

# Define the list of benchmark names: All the C++ and C benchmarks for now
base_benchmark_names=(
    "gcc"
    "perlbench"
    "omnetpp"
    "xalancbmk"
    "x264"
    "deepsjeng"
    "leela"
    "mcf"
    "xz"
    "cactuBSSN"
    "namd"
    "parest"
    "povray"
    "lbm"
    "blender"
    "imagick"
    "nab"
)

intrate_benchmarks=()
speed_benchmarks=()

for base in "${base_benchmark_names[@]}"; do
  intrate_benchmarks+=("${base}_r")
  speed_benchmarks+=("${base}_s")
done


benchmark_type="$1"
shift # Remove the type argument

# Check if the benchmark type is valid
if [ -z "$benchmark_type" ] || ! [[ "$benchmark_type" == "all" || "$benchmark_type" == "speed" || "$benchmark_type" == "intrate" ]]; then
  echo "Usage: $0 <all|speed|intrate> <target_directory>"
  echo "       <all|speed|intrate> specifies which benchmark variants to extract."
  echo "       <target_directory> is the directory where the extracted benchmarks will be placed."
  exit 1
fi

if  [[ "$benchmark_type" == "all" ]]; then

    benchmark_names=("${intrate_benchmarks[@]}" "${speed_benchmarks[@]}")
elif [[ "$benchmark_type" == "intrate" ]]; then 
    benchmark_names=("${intrate_benchmarks[@]}")
else
    benchmark_names=("${speed_benchmarks[@]}")
fi




# Define the target directory name
target_dir="extracted_benchmarks"

# Get the target directory from the command line arguments
if [ -z "$1" ]; then
  echo "Usage: $0 <target_directory>"
  echo "       <target_directory> is the directory where the extracted benchmarks will be placed."
  exit 1
fi
target_dir="$1"

# Create the target directory if it doesn't exist
mkdir -p "$target_dir"



# Loop through the benchmark names
for benchmark in "${benchmark_names[@]}"; do
  # Construct the potential base source directory path
  base_source_dir="$SPEC_DIR/benchspec/CPU/"

  # Find directories matching the benchmark name and then the build directories
  find "$base_source_dir" -maxdepth 1 -type d -name "*.${benchmark}" -print0 | while IFS= read -r -d $'\0' benchmark_dir; do
    # Construct the potential build directory path
    build_base_dir="$benchmark_dir/build/"

    # Find directories matching the mytest-m64 pattern within the build directory
    find "$build_base_dir" -maxdepth 1 -type d -name "*mytest-m64*" -print0 | while IFS= read -r -d $'\0' build_dir; do
      # Construct the full path to the executable
      executable_path="$build_dir/$benchmark"

      # Check if the executable exists
      if [ -f "$executable_path" ]; then
        # Copy the executable to the target directory, preserving the filename
        cp "$executable_path" "$target_dir/"
        echo "Copied: $executable_path to $target_dir/$benchmark"
      else
        echo "Warning: Executable not found at $executable_path"
      fi
    done
  done
done

echo "Finished extracting benchmarks to the '$target_dir' directory."