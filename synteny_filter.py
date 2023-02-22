#!/usr/bin/python
# -*- coding: utf-8 -*-

# Read gff file and filtered out sequences above limit

#LIMIT=1551 # Limit for intergenic sequences
LIMIT=50 # Limit for small proteins

import sys
import getopt
import pandas as pd

if __name__ == "__main__":
       
    unixOptions = "f:d:"  
    gnuOptions = ["file=","dir="]
    fullCmdArguments = sys.argv
    argumentList = fullCmdArguments[1:]

# reading arguments
    try:  
        arguments, values = getopt.getopt(argumentList, unixOptions, gnuOptions)
    except getopt.error as err:  
        print (str(err))
        sys.exit(2)
        
# initialize variables   
    file_input = ''
    dir_output = ''
    records=[]
    
    for currentArgument, currentValue in arguments:  
        if currentArgument in ("-f", "--file"):
            file_input = currentValue
        elif currentArgument in ("-d", "--dir"):
            dir_output = currentValue
    
    #reading file and write rows
    with open (file=file_input) as file1:
        for line in file1:
            #skip headers
            if line.startswith('#'):
                continue
            
            # Split line into columns
            records.append(line.strip().split('\t'))
            
    # convert into table
    df = pd.DataFrame(columns=['genome', 'source', 'feature','start', 'end', 'score', 'strand','frame','cluster'], data=records)
    print(f"The number of clusters: {df['cluster'].nunique()}")
    
    #group clusters
    groupby_cluster = df.groupby('cluster', as_index=False).agg({'genome':['count','nunique']})
    groupby_cluster.columns = ['clstr_id','clstr_size','clstr_nuniq']
    #max_genomes = groupby_cluster['clstr_nuniq'].max()
    
    
    #filter clusters
    filtered_clusters = list(groupby_cluster[(groupby_cluster['clstr_nuniq']==groupby_cluster['clstr_size'])&(groupby_cluster['clstr_nuniq']>1)]['clstr_id'])
    print(f"The number of filtered clusters:{len(filtered_clusters)}")
    
    #filter gff
    filtered_df = df[df['cluster'].isin(filtered_clusters)]
    
    print("Write gff...")
    #export filtered clusters
    filtered_df.to_csv(f"{dir_output}/{file_input.split('/')[-1].split('.')[0]}_block_filtered.gff", header=0, index=False, sep='\t')
            
    
