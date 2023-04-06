#!/bin/bash

output=${1-"avif"}

# Set the input and output folder paths
input_folder="."

# Iterate through all files in the input folder
for input_file in "$input_folder"/*.png; do
  # Check if the file is a PNG image
  if [ -f "$input_file" ]; then
    # Construct the output file path
    filename=$(basename "$input_file")

    # Run the FFmpeg command to convert the PNG to AVIF
    echo "npx @squoosh/cli --$output auto $input_file"
    npx @squoosh/cli --$output auto $input_file
    echo "Converted $input_file to avif"
  fi
done