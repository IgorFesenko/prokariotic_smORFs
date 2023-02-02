#!/bin/bash
# -*- coding: utf-8 -*-

# dowload genomes from NCBI, using lists

mkdir "$1"
#mkdir "$1/init_data"
#out_dir="$1/init_data"

#чтение файла по строкам
while read -r line; do
    #echo "Line: $line"
    echo "Dowloading genome $line"
    datasets download genome accession "$line" --exclude-rna --exclude-genomic-cds --exclude-gff3 --exclude-protein
    unzip ncbi_dataset.zip
    mv ncbi_dataset/data/"$line"/*.fna ./"$1"
    rm -r ncbi_dataset.zip
    rm -r ncbi_dataset
    rm README.md
    done < "$1.txt"

cd "$1"

for i in *.fna;
do
    python3 ../plasmid_remover.py --file $i
    
done