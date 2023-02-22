#!/usr/bin/python
# -*- coding: utf-8 -*-

# Filtered fasta file based on names in bed file from orfipy

from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
import sys
import getopt

if __name__ == "__main__":
       
    unixOptions = "f:b:"  
    gnuOptions = ["fasta=","bed="]
    fullCmdArguments = sys.argv
    argumentList = fullCmdArguments[1:]

# reading arguments
    try:  
        arguments, values = getopt.getopt(argumentList, unixOptions, gnuOptions)
    except getopt.error as err:  
        print (str(err))
        sys.exit(2)
        
# initialize variables   
    fasta_input = ''
    bed_input = ''
    records=[]
    names = []
    
    for currentArgument, currentValue in arguments:  
        if currentArgument in ("-f", "--fasta"):
            fasta_input = currentValue
        elif currentArgument in ("-b", "--bed"):
            bed_input = currentValue
    
    print(fasta_input)
    print(bed_input)
    
#getting ID from the file
    with open (file=bed_input) as file1:
        for line in file1:
            if line.startswith('#'):
                continue
            
            # Split line into columns
            line_features = line.strip().split('\t')
            name = line_features[3].split(';')[0].split('=')[1]
            names.append(name)

# indexing of sequences
    dict_fasta = SeqIO.index(fasta_input, "fasta")

# creating new fasta file
    for orf in names:
        records.append(SeqRecord(seq=dict_fasta[orf].seq, id=dict_fasta[orf].id, description=dict_fasta[orf].description))

    #SeqIO.write(records,f"{fasta_input.rsplit('.', maxsplit=1)[0]}.syntenic.intergenic.fa","fasta")
    #SeqIO.write(records,f"{fasta_input.rsplit('.', maxsplit=1)[0]}.intergenic.fa","fasta")
    SeqIO.write(records,f"{bed_input.rsplit('.', maxsplit=1)[0]}.fa","fasta")