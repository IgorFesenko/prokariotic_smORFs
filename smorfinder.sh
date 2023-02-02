#!/bin/bash
# -*- coding: utf-8 -*-

#predict smorfs by Smorffinder (Bhatt lab)

#conda activate finder

cd Smorf_prediciton

mkdir yersinia_smorfs

smorf meta Yersinia_combined.fa -o yersinia_smorfs -t 20 > log_yersinia_pred

mkdir cronobacter_smorfs

smorf meta Cronobacter_combined.fa -o cronobacter_smorfs -t 20 > log_cronobacter_pred


