#!/usr/bin/python
# -*- coding: utf-8 -*-

from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
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
# parsing fasta file
    records = []

    for record in SeqIO.parse(file_input, 'fasta'):   
        if not 'plasmid' in record.description:
            records.append(SeqRecord(seq=record.seq, id=record.id, description=record.description))
            
    SeqIO.write(records,f"{file_input}","fasta")