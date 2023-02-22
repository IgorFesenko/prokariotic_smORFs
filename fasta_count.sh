#!/bin/bash
# -*- coding: utf-8 -*-

# Count the number of records in fasta files in directories


INDIR="/panfs/pan1/small_orf/ORF_prediction"

echo -e "Genome\tFilename\tCount"

for dir in $INDIR/*/; do

    for file in $dir*.fa; do
        count=$(grep -c "^>" "$file")
        name=$(basename "$file")
        dname=${dir%/}
        echo -e "$dname\t$name\t$count"
        done
done