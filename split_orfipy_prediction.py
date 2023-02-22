#!/usr/bin/python
# -*- coding: utf-8 -*-

#Split large fasta files into pieces and predict orfs

import sys
import getopt
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

CHUNK_SIZE=20
counter=0
name = 0



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
    
    # Parsig fasta file
    for record in SeqIO.parse(file_input, 'fasta'):
        counter+=1
        records.append(SeqRecord(seq=record.seq, id=record.id, description=record.description))

        # write a fasta file
        if counter >= CHUNK_SIZE:
            SeqIO.write(records,f"{dir_output}/{file_input.split('/')[-1]}_chunk{name}.fa","fasta")
            records = []
            counter = 0
            name+=1
    
    #print('final write')
    # finale writing  
    SeqIO.write(records,f"{dir_output}/{file_input.split('/')[-1]}_chunk{name}.fa","fasta")