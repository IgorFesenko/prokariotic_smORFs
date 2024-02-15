#!/bin/bash
# -*- coding: utf-8 -*-

# Trimmomatic

module load trimmomatic


## TRIMMOMATIC ##

rnaseq='/data/fesenkoi2/RNAseq'

echo "Start Trimming"

while read -r line; do
    if [ "$2" = "PE" ]; then

        for file in "$line"/fq_data/*1.fastq.gz; do
            base=$(basename ${file} _1.fastq.gz)
            echo "$base"
            java -jar $TRIMMOJAR PE -threads 10  $rnaseq/$line/fq_data/"$base"_1.fastq.gz $rnaseq/$line/fq_data/"$base"_2.fastq.gz $rnaseq/$line/trimmed/"$base"_1.fastq.gz $rnaseq/$line/trimmed/"$base"_1U.fastq.gz \
            $rnaseq/$line/trimmed/"$base"_2.fastq.gz $rnaseq/$line/trimmed/"$base"_2U.fastq.gz \
            ILLUMINACLIP:/usr/local/apps/trimmomatic/0.39/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:75
        done
    else
        for file in "$line"/fq_data/*.gz; do
            filename=$(basename -- "$file")
            extension="${filename##*.}"
            filename="${filename%.*.*}"
            echo "$filename"
            java -jar $TRIMMOJAR SE -threads 10  $file $rnaseq/$line/trimmed/$filename.trimmed.fastq.gz ILLUMINACLIP:/usr/local/apps/trimmomatic/0.39/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:75
        done

    fi

done < $1

