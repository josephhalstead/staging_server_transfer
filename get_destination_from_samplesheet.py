import csv
import sys

sample_sheet = sys.argv[1]

destination = 'None'

with open(sample_sheet) as csvfile:
    spamreader = csv.reader(csvfile, delimiter=',')
    for row in spamreader:
        
    	if row[0] == 'Destination':

    		destination = row[1]

print(destination)

