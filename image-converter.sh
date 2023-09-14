#!/bin/bash

while [ $# -gt 0 ]; do
    if [[ $1 == "--"* ]]; then
        v="${1/--/}"
        declare "$v"="$2"
        shift
    fi
    shift
done

dir="${dir:-.}"
in="${in:-png}"
out="${out:-webp}"
q="${q:-auto}"

if [ $q != "auto" ]; then
  q="{"quality":$q}"
fi

echo "Input folder: $dir"
echo "Input type: $in"
echo "Output type: $out"
echo "Quality: $q"

# Iterate through all files in the in folder
for in_file in "$dir"/*."$in"; do
  # Check if the file is an image of the in type
  if [ -f "$in_file" ]; then
    # Construct the out file path
    filename=$(basename "$in_file")

    # Run the squoosh CLI command to convert the image
    npx @squoosh/cli --$out $q $in_file -d $dir
    echo "Converted $in_file to $out"
  fi
done