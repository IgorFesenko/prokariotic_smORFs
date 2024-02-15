#!/bin/bash
# -*- coding: utf-8 -*-

# Creating a set of shufled sequences

FASTA="/panfs/pan1/small_orf/intergenic"

while read -r line; do

    echo "Shuffle sequnces from $line"
    #python3 shuffler.py --file $FASTA/$line.intergenic.fa
    python ./shuffler_updated.py --file $FASTA/$line/$line.intergenic.fa --dir ./temp
    echo "Done"
done < $1