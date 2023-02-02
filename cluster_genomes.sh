#!/bin/bash
# -*- coding: utf-8 -*-



cd $1

cat *.fna > "$1_combined.fa"

/home/admin_moss/bin/Identity/bin/meshclust -d "$1_combined.fa" -o $1.clstr.txt -t 0.95

#mv $1.clstr.txt ../Clusters/