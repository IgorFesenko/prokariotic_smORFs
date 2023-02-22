#!/bin/bash
# -*- coding: utf-8 -*-

# Filter syntenic gff to bad clusters


SYNDIR="/panfs/pan1/small_orf/synteny"
OUTDIR="/panfs/pan1/small_orf/synteny"

while read -r line; do

    echo "Filtering syntenic regions in $line"
    python3 ./synteny_filter.py --file $SYNDIR/$line/"$line".blocks_coords.gff --dir $OUTDIR/$line   
    echo "Done"
    echo "================"


done < $1