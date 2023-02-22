#!/usr/bin/python
# -*- coding: utf-8 -*-

# Convert fasta file to compressed csv

from Bio import SeqIO
import pandas as pd
import sys
import getopt


if __name__ == "__main__":
       
    unixOptions = "f:"  
    gnuOptions = ["file="]
    fullCmdArguments = sys.argv
    argumentList = fullCmdArguments[1:]

# reading arguments
    try:  
        arguments, values = getopt.getopt(argumentList, unixOptions, gnuOptions)
    except getopt.error as err:  
        print (str(err))
        sys.exit(2) 
    
    file_input = ''

    
    for currentArgument, currentValue in arguments:  
        if currentArgument in ("-f", "--file"):
            file_input = currentValue
    
    # Initialize variables
    records = []
       
    # Parsig fasta file
    for record in SeqIO.parse(file_input, 'fasta'):
        records.append([record.id, record.seq, len(record.seq), record.description])

    # Convert to table
    df = pd.DataFrame(columns=['ID', 'Sequence', 'Length', 'Description'], data=records)



    df.to_csv(f"{file_input}.csv.gz", index=False, compression='gzip')