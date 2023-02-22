#!/usr/bin/python
# -*- coding: utf-8 -*-

# Read gff file and filtered out sequences above limit

#LIMIT=1551 # Limit for intergenic sequences
LIMIT=50 # Limit for small proteins

import sys
import getopt

if __name__ == "__main__":
       
    unixOptions = "f:d:"  
    gnuOptions = ["file=","dir="]
    fullCmdArguments = sys.argv
    argumentList = fullCmdArguments[1:]

# reading arguments
    try:  
        arguments, values = getopt.getopt(argumentList, unixOptions, gnuOptions)
    except getopt.error as err:  
        print (str(err))
        sys.exit(2)
        
# initialize variables   
    file_input = ''
    dir_output = ''
    records=[]
    
    for currentArgument, currentValue in arguments:  
        if currentArgument in ("-f", "--file"):
            file_input = currentValue
        elif currentArgument in ("-d", "--dir"):
            dir_output = currentValue
    
    #reading file
    with open (file=file_input) as file1:
        for line in file1:
            #writing headers
            if line.startswith('#'):
                continue
            
            # Split line into columns
            line_features = line.strip().split('\t')
            
            seqid = line_features[0]
            source = line_features[1]
            feature_type = line_features[2]
            start = int(line_features[3])
            end = int(line_features[4])
            score = line_features[5]
            strand = line_features[6]
            phase = line_features[7]
            attribute_string = line_features[8]
            
            if end - start < LIMIT:
                records.append([seqid,source,feature_type,start, end,score,strand,phase,attribute_string])
    
    with open(f'{dir_output}_intergenic.filtered.gff', 'w') as out:
        for i in records:
            out.write(f"{i[0]}\t{i[1]}\t{i[2]}\t{i[3]}\t{i[4]}\t{i[5]}\t{i[6]}\t{i[7]}\t{i[8]}\n")