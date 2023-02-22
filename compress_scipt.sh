#!/bin/bash
# -*- coding: utf-8 -*-

# Compress selected files in a folder


DIR="/panfs/pan1/small_orf/Proteins/Annot_ORFs"

while read -r line; do

    echo "Compress in $DIR/$line"
    tar czf $DIR/$line/"$line".annot.proteins.fa.tar.gz $DIR/$line/*.faa
    rm $DIR/$line/*.faa
    echo "Done"
    echo "================"


done < $1