#!/bin/bash
# -*- coding: utf-8 -*-

# Using bedtools to intersect interegenic regions and smORFs



ORF="/panfs/pan1/small_orf/ORF_prediction"
INTER="/panfs/pan1/small_orf/intergenic"

while read -r line; do

    #echo "Intersecting predicted smORFs and intergenic sequences in $line"
    #bedtools intersect -a $ORF/$line/"$line"*.bed -b $INTER/$line/"$line"_intergenic.filtered.gff -wb -f 0.8 -u > $INTER/$line/"$line"_smORFs_intergenic.bed
    
    echo "Intersecting predicted smORFs and syntenic intergenic sequences in $line"
    bedtools intersect -a $ORF/$line/"$line"*.bed -b $INTER/$line/"$line"_sinteny_intergenic.gff -wb -f 0.8 -u > $INTER/$line/"$line"_smORFs_synteny_intergenic.bed
    echo "================"


done < $1