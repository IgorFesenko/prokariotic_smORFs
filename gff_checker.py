#!/usr/bin/python
# -*- coding: utf-8 -*-

#Check if gff has malfuntions with start-end

file_input = r'/panfs/pan1/small_orf/intergenic/Shigella/Shigella_intergenic.gff'


with open (file=file_input) as f:
    for line in f:
        if line.startswith('#'):
            continue
        
        # Split line into columns
        line_features = line.strip().split('\t')
        
        if int(line_features[4])<int(line_features[3]):
            print(line_features)