#!/usr/bin/python
# -*- coding: utf-8 -*-

#Extract info about seqeunce length in fasta

import sys
import getopt
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

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
    
    # Initialize variables
    records = []
    name = file_input.split('/')[-1].split('.')[0]
    
    # Parsig fasta file
    for record in SeqIO.parse(file_input, 'fasta'):
        records.append([name, record.id, len(record.seq)])

    # writing  
    with open(f"{dir_output}/{name}_igs_length.txt", 'w') as out:
        for i in records:
            out.write(f"{i[0]}\t{i[1]}]\t{i[2]}\n")
        