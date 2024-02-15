#!/bin/bash
# -*- coding: utf-8 -*-

set -e

module load trimgalore
module load bowtie/2
module load samtools
module load fastqc
module load multiqc

######### TRIMMING AND CLEAN READS FROM RIBO-seq data ###############

riboseq='/data/fesenkoi2/RIBOseq'

echo "Start TRIMMING at $(date "+%Y-%m-%d %H:%M:%S")"

#### TRIMGALORE #####
while read -r line; do
    # Check if any files exist in the directory
    if [ -d "$riboseq/$line/trimgalore" ]; then
        echo "Directory exists. Checking..."
    else
        mkdir $riboseq/$line/trimgalore
    fi

    if [ -n "$(find "$riboseq/$line/trimgalore" -maxdepth 1 -type f -name *.gz -print -quit)" ]; then
        echo "Trimming files found in the directory. Skipping"
    else
        for file in $riboseq/"$line"/fq_data/*.gz; do
            filename=$(basename -- "$file")
            extension="${filename##*.}"
            filename="${filename%.*.*}"
            echo "$filename"
            trim_galore $file -o $riboseq/$line/trimgalore
        done
        echo "FASTQ files were trimmed at $(date "+%Y-%m-%d %H:%M:%S")"
    fi
done < $1

echo "========================================================"
echo ""

## BOWTIE2 ##
echo "Start mapping to rRNA an tRNA at $(date "+%Y-%m-%d %H:%M:%S")"

while read -r line; do
    ### Check index for rRNA ###
    directory="$riboseq/$line/rdna"
    extension=".bt2"
    if [ -n "$(find "$directory" -maxdepth 1 -type f -name $extension -print -quit)" ]; then
        echo "Directory rdna contains files with extension '$extension'."
    else
        bowtie2-build -q $riboseq/$line/rdna/*.fa $riboseq/$line/rdna/rrna
    fi

    ### Check files in directory cleaned ###
    if [ -n "$(find "$riboseq/$line/cleaned" -maxdepth 1 -type f -name *.gz -print -quit)" ]; then
        echo "Files found in the directory cleaned. Removing..."
        rm -r $riboseq/$line/cleaned
        mkdir $riboseq/$line/cleaned

    else
        echo "Directory cleaned is empty. Continue..."
    
    fi

    for file in $riboseq/$line/trimgalore/*.gz; do
        filename=$(basename -- "$file")
        extension="${filename##*.}"
        filename="${filename%.*.*}"
        echo "$filename"  
        bowtie2 -x $riboseq/$line/rdna/rrna --threads 20 --very-sensitive-local -U $file --un-gz=$riboseq/$line/cleaned/$filename.clean.fastq.gz 2>> $riboseq/$line/$filename.stats_cleaned.txt > $riboseq/$line/cleaned/rrnaAlignments.sam
        
    done
    rm $riboseq/$line/cleaned/rrnaAlignments.sam

done < $1

echo "Finished mapping to rRNA an tRNA at $(date "+%Y-%m-%d %H:%M:%S")"

## FASTQC ##
echo "Start FASTQC at $(date "+%Y-%m-%d %H:%M:%S")"

while read -r line; do
    if [ -d "$riboseq/$line/fastqc_trimgalore" ]; then
        echo "Directory exists"
        
    else
        mkdir $riboseq/$line/fastqc_trimgalore
        fastqc -t 4 -o $riboseq/$line/fastqc_trimgalore $riboseq/$line/trimgalore/*.gz # запускаем fastqc
        multiqc $riboseq/$line/fastqc_trimgalore -o $riboseq/$line/fastqc_trimgalore # объединяем отчеты при помощи multiqc
        cp $riboseq/$line/fastqc_trimgalore/multiqc_report.html /home/fesenkoi2/"$line"_trimgalore_multiqc_report.html
    fi

done < $1

## FASTQC ##
while read -r line; do
    if [ -d "$riboseq/$line/fastqc_cleaned" ]; then
        echo "Directory exists. Cleaning"
        rm -r $riboseq/$line/fastqc_cleaned
        mkdir $riboseq/$line/fastqc_cleaned
    else
        mkdir $riboseq/$line/fastqc_cleaned
    fi
    
    fastqc -t 4 -o $riboseq/$line/fastqc_cleaned $riboseq/$line/cleaned/*.gz # запускаем fastqc
    multiqc $riboseq/$line/fastqc_cleaned -o $riboseq/$line/fastqc_cleaned # объединяем отчеты при помощи multiqc
    cp $riboseq/$line/fastqc_cleaned/multiqc_report.html /home/fesenkoi2/"$line"_cleaned_multiqc_report.html
done < $1

echo "FINISHED at $(date "+%Y-%m-%d %H:%M:%S")"