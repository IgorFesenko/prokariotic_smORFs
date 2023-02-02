#!/bin/bash
# -*- coding: utf-8 -*-

# Run orfipy on overlapped with syntenic clusters IGS 


echo "Start intersect $1"
bedtools intersect -a ./$1/$1_igs_combined.gff -b ./$1_blocks/blocks_coords.gff -wb > ./$1/$1_intersect_igs_blocks.bed

echo "Getting fasta..."
bedtools getfasta -fi ./$1/$1_combined.fa -fo ./$1/$1_igs_combined_intersected.fa -bed ./$1/$1_intersect_igs_blocks.bed -name+

echo "Predict smORFs"
orfipy --start ATG,GTG,TTG --outdir ./$1/$1_igs_intersecred_orfs --bed $1_intersected_orfs.bed --dna $1_intersected_orfs.dna.fa --pep $1_intersected_orfs.pep.fa --max 150 ./$1/$1_igs_combined_intersected.fa