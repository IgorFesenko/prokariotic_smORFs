#!/bin/bash
# -*- coding: utf-8 -*-

# Filter intergenic gff to exclude IGS above 1550 nt


DIR="/panfs/pan1/small_orf/intergenic"

while read -r line; do

    echo "Filtering intergenic regions in $line"
    python3 ./filter_gff_seq_len.py --file $DIR/$line/"$line"_intergenic.gff --dir $DIR/$line/"$line"   
    echo "Done"
    echo "================"


done < $1