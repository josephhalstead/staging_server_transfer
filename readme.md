# Rsync DNA Sequencer Data

This bash script is used to monitor a directory for new directories of DNA sequencer data and then rsync the data to one of two destinations. The script also calls a Python script to parse an Illumina sample sheet CSV and determine the destination directory based on the header portion of the sample sheet.

## Usage

* Clone or download this repository.

* Modify the following variables in the script to match your local paths:
        src_dir: the path to the source directory to be monitored
        dest1_dir: the path to the first destination directory
        dest2_dir: the path to the second destination directory
        /path/to/parse_sample_sheet.py: the path to the Python script that parses the Illumina sample sheet CSV

* Make the script executable with chmod +x /path/to/rsync_dna_sequencer_data.sh.
* Set up a cron job to run the script at the desired interval.

## Details

* The script will continuously monitor the source directory for new directories, and rsync the data to one of the two destination directories determined by the Python script.

* If a new directory is found, the script creates a lock file for that directory in /tmp to prevent multiple instances of the script from running on the same directory.

* The rsync command uses the --partial option to ensure that any partially transferred files will be resumed instead of starting over.

* If the source directory doesn't contain a sample sheet CSV or if the destination directory is not recognized, the script will skip that directory and move on to the next one.

## Requirements

* rsync must be installed on the system
* The Python script used to parse the sample sheet must be installed and in the specified path
* The user running the script must have write access to /tmp and the source and destination directories.