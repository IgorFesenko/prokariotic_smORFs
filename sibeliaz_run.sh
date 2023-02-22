#!/bin/bash
# -*- coding: utf-8 -*-

# Run SibeliaZ

rep=/panfs/pan1/small_orf/synteny

while read -r line; do

    echo "Looking for sinthenic blocks in $line"
    mkdir $rep/$line
    sibeliaz -n -k 15 -o $rep/$line /panfs/pan1/small_orf/genomes/$line/$line.combined.fa
    echo "Done"
    echo "================"


done < list_genus2.txt
#sibeliaz -n -k 15 -o cronobacter_blocks ./Cronobacter/*.fna > log_sibeliaz_cronobacter
