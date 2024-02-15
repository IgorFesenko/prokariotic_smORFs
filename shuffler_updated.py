#!/usr/bin/python
# -*- coding: utf-8 -*-

from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq
import argparse
from ushuffle import shuffle, Shuffler
import random

### SCRIPT SHUFFLES NUCLEOTIDE SEQUENCES ###

if __name__ == "__main__":
       
    parser = argparse.ArgumentParser(description='Shuffling 20 percent sequnces from the fasta file with k=3')
    
    parser.add_argument("--file", type=str, help='Path to file with sequences in fasta')
    parser.add_argument("--dir", type=str, help='Path to output dir')
    args = parser.parse_args()
    
    # initialize variables   
    file_input = args.file
    out_dir = args.dir
  
               
# parsing fasta file and filter intergenic sequnces above 33nt and below 1500 nt
    records = []
    for record in SeqIO.parse(file_input, 'fasta'):
        # filtering based the length
        len_seq = len(record.seq)  
        if len_seq>32 and len_seq<1501:
            records.append(SeqRecord(seq=record.seq, id=f"{record.id}", description=record.description))

# get the size of intergenic set
    set_size = int(len(records))//5 
    print(f"Size: {set_size}")
      
    # picking up 20% of random records from the list
    record_sampled = random.sample(records,set_size)

    # Resuffling sampled sequences
    reshuffled=[] 
    for record in record_sampled:
        seq = str(record.seq)
        shuffler = shuffle(seq.encode(), 3)
        reshuffled.append(SeqRecord(seq=Seq(shuffler.decode()), id=f"{record.id}_shuffled", description=record.description))
            
    SeqIO.write(reshuffled,f"{out_dir}/{file_input.split('/')[-1].rsplit('.', maxsplit=1)[0]}.shuffled_3_20pct.fa","fasta")
