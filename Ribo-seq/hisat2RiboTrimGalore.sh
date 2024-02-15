#!/bin/bash

##### HISAT2 mapping ######

module load hisat || exit 1
module load samtools || exit 1
module load multiqc || exit 1

# $1 - list of species for download
# $2 - the number of threads
riboseq='/data/fesenkoi2/RIBOseq'

echo "Script started at $(date "+%Y-%m-%d %H:%M:%S")"
echo "Built the genome index"

while read -r line; do
    echo "Built the genome index"
    directory="$line/genome"
    extension=".ht2"
    if find "$directory" -maxdepth 1 -type f -name "*$extension" -print -quit | grep -q .; then
        echo "Directory contains files with extension '$extension'."
    else
        echo "Creating genome index"
        hisat2-build $PWD/$line/genome/*.fa $PWD/$line/genome/$line
    
    fi

done < $1

echo "Start mapping with Hisat2 at $(date "+%Y-%m-%d %H:%M:%S")"
while read -r line; do
    if find "$riboseq/$line/bam" -maxdepth 1 -type f -name "*bam" -print -quit | grep -q .; then
        rm -r  $riboseq/$line/bam/*
        rm -r $riboseq/$line/bam_stats/*
        echo "Remove previous results"
    else
        echo "Mapping started"
    fi

    for file in $riboseq/$line/cleaned/*.gz; do
            filename=$(basename -- "$file")
            extension="${filename##*.}"
            filename="${filename%.*.*}"
            echo "$filename"
            hisat2 -p $2 --summary-file $riboseq/$line/bam/$filename.log -x $riboseq/$line/genome/$line -U $file | samtools view -Sb - > $riboseq/$line/bam/"$filename".bam
            samtools sort -o $riboseq/$line/bam/"$filename".bam  $riboseq/$line/bam/"$filename".bam
            samtools index $riboseq/$line/bam/"$filename".bam
    done


done < $1

echo "Reads were mapped at $(date "+%Y-%m-%d %H:%M:%S")"

# Получаем статистику по bam файлам с помощью samtools
echo "Start MILTIQC at $(date "+%Y-%m-%d %H:%M:%S")"
while read -r line; do
    if [ -d "$riboseq/$line/bam_stats" ]; then
        echo "Directory exists. Skipping"
    else
        mkdir $riboseq/$line/bam_stats
    fi

    for file in $riboseq/$line/bam/*.bam;
    do
        echo $file
        name=$(basename $file .bam)
        samtools stats $file > $riboseq/$line/bam_stats/$name.txt
        echo "----------"
    done
    multiqc $riboseq/$line/bam_stats -o $riboseq/$line/bam_stats
    cp $riboseq/$line/bam_stats/*.html /home/fesenkoi2/MultiQC_"$line"_mapping_stats.html
done < $1

echo "Script finished at $(date "+%Y-%m-%d %H:%M:%S")"
