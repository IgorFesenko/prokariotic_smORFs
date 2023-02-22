#!/bin/bash
# -*- coding: utf-8 -*-

# Using bedtools to intersect interegenic and syntenic regions


OUTDIR="/panfs/pan1/small_orf/intergenic"

INDIR="/panfs/pan1/small_orf/synteny"


while read -r line; do

    echo "Intersecting intergenic and sintenic region in $line"
    bedtools intersect -a $OUTDIR/$line/"$line"_intergenic.filtered.gff -b $INDIR/$line/"$line"_block_filtered.gff -wb > $OUTDIR/$line/"$line"_sinteny_intergenic.gff
    #rm $OUTDIR/$line/"$line"_sinteny_intergenic.bed #$OUTDIR/$line/"$line"_sinteny_intergenic_clean.bed
    #bedtools intersect -a $OUTDIR/$line/"$line"_intergenic.gff -b $INDIR/$line/"$line".blocks_coords.gff > $OUTDIR/$line/"$line"_sinteny_intergenic_clean.bed
    echo "Done"
    echo "================"


done < $1