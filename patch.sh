#!/bin/bash

# Aarch64 Gracehopper Image to use 
NEW_IMAGE="nvcr.io/nvidia/mlperf/mlperf-inference:mlpinf-v4.1-cuda12.4-pytorch24.04-ubuntu22.04-aarch64-GraceHopper-release"

CURR_DIR=$PWD
RUN_DIR="${CURR_DIR}/script"

cd "$RUN_DIR" || { echo "Directory $RUN_DIR not found."; exit 1; }

# Find all relevant files containing x86 MLPerf images and replace them with the new aarch64 image
grep -rl "nvcr.io/nvidia/mlperf/mlperf-inference" . | while read -r file; do
    sed -i.bak "/nvcr.io\/nvidia\/mlperf\/mlperf-inference/ {
        /x86_64/ s|nvcr.io/nvidia/mlperf/mlperf-inference:[^ ]*|$NEW_IMAGE|g
    }" "$file"
    echo "Updated MLPerf x86 image in: $file"
done

find . -name "*.bak" -type f -delete

