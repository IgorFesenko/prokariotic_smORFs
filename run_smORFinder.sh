#!/bin/bash
# -*- coding: utf-8 -*-

# Run smORFinder to predict potentiall functional ORFs

INDIR="/panfs/pan1/small_orf/genomes"

OUTDIR="/panfs/pan1/small_orf/SmORFinder"


while read -r line; do

    echo "Predicting ORFs from $line"
    mkdir $OUTDIR/$line
    smorf meta $INDIR/$line/"$line".combined.fa -o $OUTDIR/$line -t 20
    echo "Done"
    echo "================"


done < $1