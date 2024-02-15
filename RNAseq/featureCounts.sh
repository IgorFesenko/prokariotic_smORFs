#!/bin/bash
set -e
module load subread

#RUN feature counts

# Preparing to RNA seq analysis
# $1 - list of species for analysis


while read -r line; do
    echo "$line"
    if [ "$2" = "PE" ]; then
        featureCounts -T 10 -p --countReadPairs -t gene,smORF,exon,ncRNA,rRNA,tRNA,tmRNA -g ID -a $PWD/$line/$line*.gff -o $PWD/$line/"$line"_FeatureCounts $PWD/$line/bam/Combined.bam
	cp $PWD/$line/"$line"_FeatureCounts /home/fesenkoi2
    else
        featureCounts -T 10 -a $PWD/$line/$line*.gff -t gene,smORF,exon,ncRNA,rRNA,tRNA,tmRNA -g ID -o $PWD/$line/"$line"_FeatureCounts $PWD/$line/bam/Combined.bam
	cp $PWD/$line/"$line"_FeatureCounts /home/fesenkoi2
    fi
done < $1
