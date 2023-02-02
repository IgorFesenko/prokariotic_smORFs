#!/usr/bin/python
# -*- coding: utf-8 -*-


import sys
import getopt



if __name__ == "__main__":
       
    unixOptions = "f:"  
    gnuOptions = ["file="]
    fullCmdArguments = sys.argv
    argumentList = fullCmdArguments[1:]

# reading arguments
    try:  
        arguments, values = getopt.getopt(argumentList, unixOptions, gnuOptions)
    except getopt.error as err:  
        print (str(err))
        sys.exit(2) 
    
    file_input = '' 
    
    for currentArgument, currentValue in arguments:  
        if currentArgument in ("-f", "--file"):
            file_input = currentValue 

    result_gff = []
    feature_list = []

    #reading file
    with open (file=file_input) as file1:
        for line in file1:
            if line.startswith('#'):
                pass
            else:
                feature_list.append(line.strip().split('\t'))  
    
    #remove CDS
    genes = [g for g in feature_list if g[2]=='gene']

    #parsing data
    for i in range(len(genes)-1):
        if genes[i][2] == 'gene':
            my_start = genes[i][4]
            my_end = genes[i+1][3]
            if int(my_end)-int(my_start)>32:
                seqname = genes[i][0]
                source = genes[i][1]
                feature = genes[i][2]
                score =  genes[i][5]
                strand = genes[i][6]
                frame = genes[i][7]
                attr1 = genes[i][8]
                attr2 = genes[i+1][8]
                attr = f"{attr1.split(';')[1]}_{attr2.split(';')[1]}"
                result_gff.append([seqname,source,feature,my_start+1,my_end-1,score, strand, frame,attr])
            else:
                pass

        else:
            pass

    ##add last piece of genome
    last_start = my_end
    last_stop = feature_list[0][4]
    if int(last_stop)-int(last_start)>32:
        last_attr1 = genes[-1][8].split(';')[1]
        last_attr2 = genes[0][8].split(';')[1]
        attr = f"{last_attr1}_{last_attr2}"

        result_gff.append([seqname,source,feature,last_start,last_stop,score, strand, frame, attr])


    with open(f"{file_input.split('.')[0]}_igs.gff", 'w') as out:
        for i in result_gff:
            out.write(f"{i[0]}\t{i[1]}\t{i[2]}\t{i[3]}\t{i[4]}\t{i[5]}\t{i[6]}\t{i[7]}\t{i[8]}\n")