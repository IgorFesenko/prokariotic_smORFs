#!/bin/bash
# -*- coding: utf-8 -*-

# Show the number of dowloaded genomes and input file

while read -r line; do
        echo "Genomes in $line"
        grep -c "^>" /panfs/pan1/small_orf/genomes/$line/"$line.combined.fa"
        echo "Annotations:"
        grep -c "gff-version 3" /panfs/pan1/small_orf/genomes/$line/"$line.combined.gff"
    done < list_genus.txt