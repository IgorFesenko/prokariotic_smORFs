#!/bin/bash
# -*- coding: utf-8 -*-

# Extract sequence length from fasta files

INDIR="/panfs/pan1/small_orf/ORF_prediction"

OUTDIR="/panfs/pan1/small_orf/temp"

#mkdir $OUTDIR/intergenic_length

while read -r line; do

    echo "Extract data $line"
    python3 ./sequence_len_from_fasta.py --file $INDIR/$line/"$line"*.pep.syntenic.intergenic.fa --dir $OUTDIR/
    echo "Done"
    echo "================"


done < $1