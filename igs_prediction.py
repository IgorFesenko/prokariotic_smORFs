#!/usr/bin/python
# -*- coding: utf-8 -*-


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
    
    file_input = ''
    dir_output = ''
    
    for currentArgument, currentValue in arguments:  
        if currentArgument in ("-f", "--file"):
            file_input = currentValue
        elif currentArgument in ("-d", "--dir"):
            dir_output = currentValue

    result_gff = []
    feature_list = []

    with open (file=file_input) as f:
    
        # Initialize variables
        prev_end = 0
        seqid = None
        source = 'RefSeq'
        feature = 'intergenic'
        score = '.'
        strand = '+'
        frame = "."
        upstream_gene = None
        downstream_gene = None
        upstream_feature = None
    
        # Loop through each line of the file
        for line in f:
            if line.startswith('#'):
                continue
        
            # Split line into columns
            line_features = line.strip().split('\t')
            

            if line_features[2] == 'region':
                if prev_end != 0:
                    if prev_end<global_end:
                        attr = f"{upstream_gene},{upstream_feature};None"
                        result_gff.append([seqid,source, feature, prev_end, global_end, score, strand,frame,attr])
                seqid = line_features[0]
                global_end = int(line_features[4])
                global_start = int(line_features[3])
                prev_end = 0
                continue

            if line_features[2] not in ['gene', 'pseudogene']:
                continue
        
            # Calculate start intergenic region for genome
            if prev_end == 0:
                attr = f"None;{line_features[8].split(';')[0]},{line_features[6]}"
                result_gff.append([seqid,source, feature, global_start, line_features[3], score, strand,frame,attr])
                prev_end=int(line_features[4])
                continue
            # Check if previous end coordinate exists
            if prev_end != 0:

            # Calculate intergenic region start and end coordinates
                intergenic_start = prev_end + 1
                intergenic_end = int(line_features[3]) - 1
                downstream_gene = line_features[8].split(';')[0]
                attr = f"{upstream_gene},{upstream_feature};{downstream_gene},{line_features[6]}"
                if intergenic_end < intergenic_start:
                    result_gff.append([seqid,source,feature,intergenic_end,intergenic_start,score, strand, frame, attr])
                else:
                    result_gff.append([seqid,source,feature,intergenic_start,intergenic_end,score, strand, frame, attr])
                
                
            # Update previous end coordinate
            prev_end = int(line_features[4])
            upstream_gene = line_features[8].split(';')[0]
            upstream_feature = line_features[6]
        

    with open(f'{dir_output}_intergenic.gff', 'w') as out:
        for i in result_gff:
            out.write(f"{i[0]}\t{i[1]}\t{i[2]}\t{i[3]}\t{i[4]}\t{i[5]}\t{i[6]}\t{i[7]}\t{i[8]}\n")

