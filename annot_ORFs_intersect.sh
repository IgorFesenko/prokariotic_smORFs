#!/bin/bash
# -*- coding: utf-8 -*-

# Using bedtools to find coordinated of proteins and intersect with syntenic regions


ORF="/panfs/pan1/small_orf/ORF_prediction"
OUTDIR="/panfs/pan1/small_orf/Proteins/Annot_ORFs"
SYNDIR="/panfs/pan1/small_orf/synteny"
GENDIR="/panfs/pan1/small_orf/genomes"


while read -r line; do

    echo "Finding ORFs coordinates in $line"
    bedtools intersect -u -f 0.9 -r -s -a $ORF/$line/"$line"*.bed -b $GENDIR/$line/$line.combined.gff > $OUTDIR/$line/$line.ORFs.annot.bed
    bedtools intersect -wa -wb -f 0.9 -r -s -a $ORF/$line/"$line"*.bed -b $GENDIR/$line/$line.combined.gff > $OUTDIR/$line/$line.ORFs.intersection_info
    echo "Done"
    echo "Extract protein ORFs from $line"
    python3 ./fasta_filtration_by_name.py --fasta $ORF/$line/"$line"*pep.fa --bed $OUTDIR/$line/$line.ORFs.annot.bed
    echo "Done"
    echo "Intersect with syntenic regions in $line"
    bedtools intersect -u -f 0.8 -a $OUTDIR/$line/$line.ORFs.annot.bed -b $SYNDIR/$line/"$line"_block_filtered.gff > $OUTDIR/$line/$line.ORFs.annot_synteny.bed
    echo "Done"
    echo "Extract syntenic ORFs from $line"
    python3 ./fasta_filtration_by_name.py --fasta $OUTDIR/$line/$line.ORFs.annot.fa --bed $OUTDIR/$line/$line.ORFs.annot_synteny.bed
    echo "Done"
    echo "Split annot protein fasta $line"
    python3 ./fasta_split_by_length.py --fasta $OUTDIR/$line/$line.ORFs.annot.fa
    echo "Done"
    echo "Split syntenic annot fasta $line"
    python3 ./fasta_split_by_length.py --fasta $OUTDIR/$line/$line.ORFs.annot_synteny.fa
    echo "Done"
    echo "================"

done < $1