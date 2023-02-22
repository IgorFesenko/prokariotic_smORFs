#!/bin/bash
# -*- coding: utf-8 -*-

# Run orfipy

INDIR="/panfs/pan1/small_orf/genomes"

OUTDIR="/panfs/pan1/small_orf/ORF_prediction"


while read -r line; do

    echo "Getting ORFs from $line"
    mkdir $OUTDIR/$line
    orfipy --start ATG,GTG,TTG --outdir $OUTDIR/$line --bed "$line"_sorfs.bed --dna "$line"_sorfs.dna.fa --pep "$line"_sorfs.pep.fa $INDIR/$line/"$line".combined.fa
    echo "Done"
    echo "================"


done < $1