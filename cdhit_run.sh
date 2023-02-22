#!/bin/bash
# -*- coding: utf-8 -*-

# Run cd-hit to cluster sequences


FASTA="/panfs/pan1/small_orf/ORF_prediction"
OUTDIR="/panfs/pan1/small_orf/CDHIT_clusters"

while read -r line; do

    echo "Start clustering...$line"
    mkdir $OUTDIR/$line
    cd-hit -i $FASTA/$line/"$line"*.pep.intergenic.fa -o $OUTDIR/$line/"$line".95pep_clstr -n 2 -c 0.5 -d 200 -M 10000 -l 5 -s 0.95 -aL 0.95 -g 1
    perl ~/bin/cdhit-master/clstr2txt.pl $OUTDIR/$line/"$line".95pep_clstr.clstr > $OUTDIR/$line/"$line".95pep_clstr.clstr_text
    echo "Done"
    echo "================"
    #cd-hit -i $FASTA/$line/"$line"*.pep.intergenic.fa -o $OUTDIR/"$line".90pep_clstr -n 2 -c 0.5 -d 200 -M 10000 -l 5 -s 0.90 -aL 0.90 -g 1
    #perl ~/bin/cdhit-master/clstr2txt.pl $OUTDIR/"$line".90pep_clstr > "$line"_90.pep_clstr_text
    #echo "Done"
    #echo "================"
    #cd-hit -i $FASTA/$line/"$line"*.pep.intergenic.fa -o $OUTDIR/"$line".80pep_clstr -n 2 -c 0.5 -d 200 -M 10000 -l 5 -s 0.80 -aL 0.80 -g 1
    #perl ~/bin/cdhit-master/clstr2txt.pl $OUTDIR/"$line".80pep_clstr > "$line"_80.pep_clstr_text
    #echo "Done"
    #echo "================"

done < $1


# -n 2 for thresholds 0.4 ~ 0.5
# -c sequence identity threshold, default 0.9
# -M max available memory (Mbyte), default 400
# -s length difference cutoff, default 0.0 if set to 0.9, the shorter sequences need to be at least 90% length of the representative of the cluster
# -aL alignment coverage for the longer sequence, default 0.0 if set to 0.9, the alignment must covers 90% of the sequence
# -g 1 or 0, default 0 By cd-hit’s default algorithm, a sequence is clustered to the first cluster that meet the threshold (fast mode). If set to 1, the program
# will cluster it into the most similar cluster that meet the threshold (accurate but slow mode)