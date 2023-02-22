#!/usr/bin/python
# -*- coding: utf-8 -*-

# split fasta file based on seuence threshold

from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
import sys
import getopt

SEQ_THRESH = 70

if __name__ == "__main__":
       
    unixOptions = "f:"  
    gnuOptions = ["fasta="]
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
    
    records_below=[]
    records_above=[]
    
    for currentArgument, currentValue in arguments:  
        if currentArgument in ("-f", "--fasta"):
            fasta_input = currentValue
        
    
    print(fasta_input)
    
    
# indexing of sequences
    for record in SeqIO.parse(fasta_input, 'fasta'):
        if len(record.seq) <= SEQ_THRESH:
            records_below.append(SeqRecord(seq=record.seq, id=record.id, description=record.description))
            continue
        records_above.append(SeqRecord(seq=record.seq, id=record.id, description=record.description))

# writing new fasta file
    SeqIO.write(records_below,f"{fasta_input.rsplit('.', maxsplit=1)[0]}.below{SEQ_THRESH}.fa","fasta")
    SeqIO.write(records_above,f"{fasta_input.rsplit('.', maxsplit=1)[0]}.above{SEQ_THRESH}.fa","fasta")
    #SeqIO.write(records,f"{fasta_input.rsplit('.', maxsplit=1)[0]}.intergenic.fa","fasta")
    #SeqIO.write(records,f"{bed_input.rsplit('.', maxsplit=1)[0]}.fa","fasta")