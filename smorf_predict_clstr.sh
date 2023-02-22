#!/bin/bash
# -*- coding: utf-8 -*-

# Run orfipy and predit smORFs

cd $1
echo $PWD
echo "Start predicting smORFs..."
orfipy --start ATG,GTG,TTG --outdir "$1_igs_orfs" --bed "$1_igs_orfs.bed" --dna "$1_igs_orfs.dna.fa" --pep "$1_igs_orfs.pep.fa" --max 150 "$1_igs_combined.fa"
echo "Done"
cd $1_igs_orfs
echo "Start clustering..."
cd-hit -i $1_igs_orfs.pep.fa -o $1_igs_orfs.pep_clstr -n 2 -c 0.5 -d 200 -M 5000 -l 5 -s 0.95 -aL 0.95 -g 1
perl /home/admin_moss/cdhit/clstr2txt.pl $1_igs_orfs.pep_clstr.clstr > $1_igs_orfs.pep_clstr_text
echo "Done"

