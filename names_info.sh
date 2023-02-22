#!/bin/bash
# -*- coding: utf-8 -*-

# Look at downloaded genomes

INDIR="/panfs/pan1/small_orf/genomes"

OUTDIR="/panfs/pan1/small_orf/species_info"


while read -r line; do

    echo "Geeting info from $line"
    python3 ./names_extractor.py --file $INDIR/$line/"$line.combined.gff" --dir $OUTDIR/$line
    echo "Done"
    echo "================"


done < $1