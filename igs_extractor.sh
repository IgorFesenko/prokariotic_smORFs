#!/bin/bash
# -*- coding: utf-8 -*-

# Extract IGS from gff files

INDIR="/panfs/pan1/small_orf/genomes"

OUTDIR="/panfs/pan1/small_orf/intergenic"


while read -r line; do

    echo "Extract intergenic regions for $line"
    #mkdir $OUTDIR/$line
    #python3 ./igs_prediction.py --file $INDIR/$line/"$line.combined.gff" --dir $OUTDIR/$line/$line
    echo "Getting fasta..."
    bedtools getfasta -name+ -fi $INDIR/$line/"$line".combined.fa -bed $OUTDIR/$line/"$line"_intergenic.filtered.gff -fo $OUTDIR/$line/$line.intergenic.fa

    echo "Done"
    echo "================"


done < $1