#!/bin/bash
# -*- coding: utf-8 -*-

# HISAT2

module load hisat || exit 1
module load samtools || exit 1
module load multiqc || exit 1

echo "Built the genome index"

while read -r line; do
    echo "Built the genome index"
    directory="$line/genome"
    extension=".ht2"
    if find "$directory" -maxdepth 1 -type f -name "*$extension" -print -quit | grep -q .; then
        echo "Directory contains files with extension '$extension'."
    else
        echo "Creating genome index"
        for fasta in $line/genome/*.fa; do
            hisat2-build $fasta $PWD/$line/genome/$line
        done 
    fi

done < $1

echo "Start mapping with Hisat2"
while read -r line; do
    if [ "$2" = "PE" ]; then

        for file in "$line"/trimmed/*1.fastq.gz; do
            base=$(basename ${file} _1.fastq.gz)
            echo "$base mapping"
            hisat2 -p 30 --no-softclip --summary-file $PWD/$line/bam/$base.log -x $PWD/$line/genome/$line -1 $PWD/$line/trimmed/"$base"_1.fastq.gz -2 $PWD/$line/trimmed/"$base"_2.fastq.gz | samtools view -Sb - > $PWD/$line/bam/"$base".bam
            echo "Sort $base.bam"
            samtools sort -o $PWD/$line/bam/"$base".bam  $PWD/$line/bam/"$base".bam
            samtools index $PWD/$line/bam/"$base".bam
        done
    else
        for file in "$line"/trimmed/*.gz; do
            filename=$(basename -- "$file")
            extension="${filename##*.}"
            filename="${filename%.*.*}"
            echo "$filename"
            hisat2 -p 30 --no-softclip --summary-file $line/bam/$filename.log -x $PWD/$line/genome/$line -U $file | samtools view -Sb - > $PWD/$line/bam/"$filename".bam
	    samtools sort -o $PWD/$line/bam/"$filename".bam  $PWD/$line/bam/"$filename".bam
	    samtools index $PWD/$line/bam/"$filename".bam
        done

    fi

done < $1

echo "Reads were mapped"


# Получаем статистику по bam файлам с помощью samtools
echo "Start MILTIQC"
while read -r line; do
    mkdir $line/bam_stats
    for file in $PWD/$line/bam/*.bam;
    do
        echo $file
        name=$(basename $file .bam)
        samtools stats $file > $PWD/$line/bam_stats/$name.txt
        echo "----------"
    done
    multiqc $PWD/$line/bam_stats -o $PWD/$line/bam_stats
    mv $PWD/$line/bam_stats/*.html /home/fesenkoi2/MultiQC_"$line"_mapping_stats.html
done < $1

echo "Script completed"
