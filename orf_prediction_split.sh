#!/bin/bash
# -*- coding: utf-8 -*-

# Run orfipy


INDIR="/panfs/pan1/small_orf/genomes"

OUTDIR="/panfs/pan1/small_orf/ORF_prediction"

TEMP="/panfs/pan1/small_orf/temp"


while read -r line; do

    echo "Getting ORFs for $line"
    #mkdir $OUTDIR/$line
    echo "Split fasta file"
    python3 ./split_orfipy_prediction.py --file $INDIR/$line/"$line.combined.fa" --dir $TEMP
    
    echo "Getting ORFs..."
    for chunk in $TEMP/*chunk*; do
        echo $chunk
        orfipy --start ATG,GTG,TTG --outdir $TEMP --bed "$chunk"_sorfs.bed --dna "$chunk"_sorfs.dna.fa --pep "$chunk"_sorfs.pep.fa $chunk
    done   

    cat $TEMP/*_sorfs.bed > $OUTDIR/$line/$line.sorfs.bed
    cat $TEMP/*_sorfs.dna.fa > $OUTDIR/$line/$line.sorfs.dna.fa
    cat $TEMP/*_sorfs.pep.fa > $OUTDIR/$line/$line.sorfs.pep.fa
    #cat $TEMP/*log > $OUTDIR/$line/$line.sorfs.log
    rm $TEMP/$line*
    echo "Done"
    echo "================"


done < $1