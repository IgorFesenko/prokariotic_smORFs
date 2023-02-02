#!/bin/bash
# -*- coding: utf-8 -*-

# Run SibeliaZ

mkdir erwinia_blocks

sibeliaz -n -k 15 -o erwinia_blocks ./Erwinia/*.fna > log_sibeliaz_erwinia

mkdir cronobacter_blocks

sibeliaz -n -k 15 -o cronobacter_blocks ./Cronobacter/*.fna > log_sibeliaz_cronobacter

mkdir yersinia_blocks

sibeliaz -n -k 15 -o yersinia_blocks ./Yersinia/*.fna > log_sibeliaz_yersinia