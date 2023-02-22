#!/usr/bin/python
# -*- coding: utf-8 -*-

#Extract info about fasta ID and accession number from gff

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
            
    with open (file=file_input) as f:
    
        # Initialize variables
        acc_info = []
        chr_info = []
        checker = 0
    
        # Loop through each line of the file
        for line in f:
            
            if line.startswith('#!genome-build-accession'):
                acc_info.append(line.strip().split(':')[1])
                checker = 1
            elif line.startswith('##sequence-region') and checker == 1:
                chr_info.append(line.strip().split(' ')[1])
                checker = 0
                
    out_lst = list(zip(acc_info,chr_info))
    
    with open(f'{dir_output}_names.txt', 'w') as out:
        for i in out_lst:
            out.write(f"{i[0]}\t{i[1]}\n")
                
                