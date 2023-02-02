#!/bin/bash

set -u

# Set the source and destination directories
src_dir="source/"
awmgs_dir="awmgs_nhs/"
wales_gene_park_dir="wales_gene_park/"

# Find all new directories in the source directory
for dir in $(find "$src_dir" -mindepth 1 -maxdepth 1 -type d); do

  # Set the path to the lock file for this directory
  lock_file="/tmp/$(basename "$dir").rsync_lock"

  # Check if the lock file for this directory exists
  if [ -f "$lock_file" ]; then
    # If the lock file exists, do nothing and continue to the next directory
    continue
  fi

  # Create the lock file for this directory
  touch "$lock_file"

  # Check if the directory contains an Illumina sample sheet CSV
  sample_sheet=$(find "$dir" -name "SampleSheet.csv" | head -n 1)

  if [ -z "$sample_sheet" ]; then
    # If the directory doesn't contain a sample sheet, remove the lock file and continue to the next directory
    rm "$lock_file"
    continue
  fi

  # Call the Python script to parse the Illumina sample sheet CSV and determine the destination directory
  dest=$(python get_destination_from_samplesheet.py "$sample_sheet")

  if [ "$dest" == "awmgs_nhs" ]; then
    dest_dir="$awmgs_dir"
  elif [ "$dest" == "wales_gene_park" ]; then
    dest_dir="$wales_gene_park_dir"
  else
    # If the destination is not recognized, remove the lock file and continue to the next directory
    rm "$lock_file"
    continue
  fi

  # Rsync the new directory to the determined destination with the --partial option
  rsync -av "$dir" "$dest_dir"

  # Remove the lock file for this directory
  rm "$lock_file"
done
