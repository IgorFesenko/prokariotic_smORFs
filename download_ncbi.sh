#!/bin/bash
# -*- coding: utf-8 -*-

# dowload genomes and gff from NCBI, using lists

#conda init bash

#conda activate smorfs

rep=/panfs/pan1/small_orf/genomes

cd genomes

for file in *.txt; do
    filename=$(basename -- "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"
    echo "Creating folder $filename"
    #mkdir $filename
    mkdir $rep/$filename
    echo "Start genomes download:"
    while read -r line; do
        echo "Dowloading genome $line"
        datasets download genome accession "$line" --filename ncbi_dataset.zip --include 'genome','gff3'
        unzip ncbi_dataset.zip

        #remove plasmids
        echo "Remove plasmids..."
        python3 $HOME/plasmid_remover.py --file ncbi_dataset/data/"$line"/*.fna
        
        #moving genome file
        echo "moving .fna to $filename"
        #mv ncbi_dataset/data/"$line"/*.fna ./"$filename"
        mv ncbi_dataset/data/"$line"/*.fna $rep/$filename

        echo "moving $gff_filename.gff to $filename"
        #mv ncbi_dataset/data/"$line"/*.gff ./"$filename/$line.gff"
        mv ncbi_dataset/data/"$line"/*.gff $rep/$filename/"$line.gff"
        #remove temporary files
        rm -r ncbi_dataset.zip
        rm -r ncbi_dataset
        rm README.md
        echo "Done"
    done < "$file"


    #concatenate data
    #cd $filename
    #cd $rep/$filename/
    cat $rep/$filename/*.fna > $rep/$filename/$filename.combined.fa
    cat $rep/$filename/*.gff > $rep/$filename/$filename.combined.gff3
    rm $rep/$filename/*.fna
    rm $rep/$filename/*.gff
    mv $rep/$filename/$filename.combined.gff3 $rep/$filename/$filename.combined.gff
    #cd ..
    #cd genomes
    #mv $filename /panfs/pan1/small_orf/genomes/$filename
    echo "============================"
done


