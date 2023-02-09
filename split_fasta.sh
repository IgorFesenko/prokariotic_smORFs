#!/bin/bash

# Check if the file exists
if [ ! -f "$1" ]; then
  echo "Error: File not found."
  exit 1
fi

# Set the input file and initialize counters
input_file="$1"
counter=0
block=1

# Create the output file name
output_file="split_$block.fasta"

# Read the input file line by line
while read line; do
  # Check if the line starts with a ">" character
  if [ "${line:0:1}" == ">" ]; then
    # Increment the counter
    counter=$((counter+1))
  fi

  # Write the line to the output file
  echo "$line" >> "$output_file"

  # Check if the counter has reached 20
  if [ "$counter" -eq 20 ]; then
    # Reset the counter
    counter=0

    # Increment the block number
    block=$((block+1))

    # Create the next output file name
    output_file="split_$block.fasta"
  fi
done < "$input_file"
