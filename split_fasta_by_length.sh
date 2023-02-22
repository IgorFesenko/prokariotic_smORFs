#!/bin/bash
# -*- coding: utf-8 -*-

# Split fasta file based on length

#INDIR="/panfs/pan1/small_orf/Proteins/Annot_ORFs"
INDIR="/panfs/pan1/small_orf/temp"


while read -r line; do

    echo "Extract data $line"
    python3 ./fasta_split_by_length.py --fasta $INDIR/$line/GCF*.faa
    echo "Done"
    echo "================"


done < $1