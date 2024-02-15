#!/bin/bash
# -*- coding: utf-8 -*-

# Analysing the reads quality by FASTQC

module load fastqc
module load multiqc


echo "Performing FASTQC analysis of raw reads quality"
while read -r line; do
    fastqc -t 4 -o $PWD/$line/fastqc_cleaned $PWD/$line/cleaned/* # запускаем fastqc
    multiqc $PWD/$line/fastqc_cleaned -o $PWD/$line/fastqc_cleaned # объединяем отчеты при помощи multiqc
    cp $PWD/$line/fastqc_cleaned/multiqc_report.html /home/fesenkoi2/"$line"_cleaned_multiqc_report.html
done < $1
