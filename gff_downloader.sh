#!/bin/bash
# -*- coding: utf-8 -*-

# dowload gff from NCBI, using lists



#чтение файла по строкам
while read -r line; do
    #echo "Line: $line"
    echo "Dowloading gff from $line..."
    datasets download genome accession "$line" --exclude-rna --exclude-genomic-cds --exclude-protein
    unzip ncbi_dataset.zip
    mv ncbi_dataset/data/"$line"/*.gff ./"$1"/$line.gff
    rm -r ncbi_dataset.zip
    rm -r ncbi_dataset
    rm README.md
    done < "$1.txt"

cd "$1"

#extract IGS regions from gffs
echo "Extraxting IGS..."
for i in *.gff;
do
    python3 ../igs_extractor.py --file $i
    
done

cat *igs.gff > "$1_igs_combined.gff"