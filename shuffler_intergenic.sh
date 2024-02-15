#!/bin/bash
# -*- coding: utf-8 -*-

# Creating a set of shufled intergenic sequences

FASTA="path-to-directory-with-fasta"

while read -r line; do

    echo "Shuffle sequnces from $line"
    python ./shuffler_updated.py --file $FASTA/$line/$line.intergenic.fa --dir ./temp
    echo "Done"
done < $1
