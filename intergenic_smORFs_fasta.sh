#!/bin/bash
# -*- coding: utf-8 -*-

# Extract peptide sequences for smORFs from overall prediction


FASTA="/panfs/pan1/small_orf/ORF_prediction"
BED="/panfs/pan1/small_orf/intergenic"

while read -r line; do

    #echo "Extract intergenic smORFs from $line"
    #python3 ./fasta_filtration_by_name.py --fasta $FASTA/$line/"$line"*pep.fa --bed $BED/$line/"$line"_smORFs_intergenic.bed
    echo "Extract syntenic smORFs from $line"
    python3 ./fasta_filtration_by_name.py --fasta $FASTA/$line/"$line"*pep.fa --bed $BED/$line/"$line"_smORFs_synteny_intergenic.bed  
    echo "Done"
    echo "================"


done < $1