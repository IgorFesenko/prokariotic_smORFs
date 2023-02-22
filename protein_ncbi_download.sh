#!/bin/bash
# -*- coding: utf-8 -*-

# dowload genomes and gff from NCBI, using lists

#conda init bash

#conda activate smorfs


INDIR="./genomes"
OUTDIR="/panfs/pan1/small_orf/Proteins/Annot_ORFs"

for file in $INDIR/*.txt; do
    filename=$(basename -- "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"
    echo "Creating folder $filename"
    mkdir $OUTDIR/$filename

    echo "Start download $file:"
    while read -r line; do
        echo "Dowloading $line"
        datasets download genome accession "$line" --filename ncbi_dataset.zip --include 'protein'
        unzip ncbi_dataset.zip
        
        #moving protein file
        echo "moving .faa to $filename"
        mv ncbi_dataset/data/"$line"/*.faa $OUTDIR/$filename/"$line".protein.faa

        #remove temporary files
        rm -r ncbi_dataset.zip
        rm -r ncbi_dataset
        rm README.md
        echo "DONE"
    done < "$file"
    echo "============================"
done
