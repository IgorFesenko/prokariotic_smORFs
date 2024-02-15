#!/bin/bash
# -*- coding: utf-8 -*-

set -e

#####  MAPPING RIBO-SEQ READS BY BOWTIE2 SENSITIVE ALGORITHM ######

module load bowtie/2
module load samtools
module load fastqc
module load multiqc

# $1 - list of species for download
# $2 - the number of threads

riboseq='RIBOseq'

echo "Script started at $(date "+%Y-%m-%d %H:%M:%S")"


### GENOME INDEX #####
while read -r line; do
    echo "Built the genome index for $line"
    #### Check if indes has been already created ####
    directory="$riboseq/$line/genome"
    extension=".bt2"
    if [ -n "$(find "$directory" -maxdepth 1 -type f -name $extension -print -quit)" ]; then
        echo "Directory contains files with extension '$extension'."
    else
        bowtie2-build -q $riboseq/$line/genome/*.fa $riboseq/$line/genome/$line
    fi

    echo "Genome index created  at $(date "+%Y-%m-%d %H:%M:%S")" 


    
    ### Check if directory exist ###
    if [ -d "$riboseq/$line/bam_bowtie" ]; then
        echo "Directory <bam_bowtie> exists. Cleaning previous results..."
        rm -r $riboseq/$line/bam_bowtie
        mkdir $riboseq/$line/bam_bowtie
        
    else
        mkdir $riboseq/$line/bam_bowtie
    fi
    
    ### BOWTIE2 ####
    echo "Start mapping in $line with Bowtie2 at $(date "+%Y-%m-%d %H:%M:%S")"
    for file in $riboseq/$line/cleaned/*.gz; do
        filename=$(basename -- "$file")
        extension="${filename##*.}"
        filename="${filename%.*.*}"
        echo "$filename"  
        bowtie2 -x $riboseq/$line/genome/$line --threads $2 --very-sensitive-local -U $file | samtools view -Sb - > $riboseq/$line/bam_bowtie/"$filename"_bowtie.bam

        samtools sort -O BAM -@3 -T /lscratch/$SLURM_JOB_ID/temp -m 2g -o$riboseq/$line/bam_bowtie/"$filename"_bowtie.bam $riboseq/$line/bam_bowtie/"$filename"_bowtie.bam
        samtools index $riboseq/$line/bam_bowtie/"$filename"_bowtie.bam
    done

done < $1

echo "Reads were mapped to $line genome at $(date "+%Y-%m-%d %H:%M:%S")"

### MULTIQC #####
echo "Start MILTIQC at $(date "+%Y-%m-%d %H:%M:%S") for $line data"
while read -r line; do
    if [ -d "$riboseq/$line/bam_stats_bowtie" ]; then
        echo "Directory bam_stats_bowtie exists. Cleaning..."
        rm -r  $riboseq/$line/bam_stats_bowtie
        mkdir $riboseq/$line/bam_stats_bowtie
    else
        mkdir $riboseq/$line/bam_stats_bowtie
    fi

    for file in $riboseq/$line/bam_bowtie/*.bam;
    do
        echo $file
        name=$(basename $file .bam)
        samtools stats $file > $riboseq/$line/bam_stats_bowtie/$name.txt
        echo "----------"
    done
    multiqc $riboseq/$line/bam_stats_bowtie -o $riboseq/$line/bam_stats_bowtie
    
done < $1

echo "Script finished at $(date "+%Y-%m-%d %H:%M:%S")"
