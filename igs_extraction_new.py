file_name = r'/Users/igorfesenko/Yandex Диск/Yandex.Disk.localized/prokaryotic_smORFs/raw_data/test_igv/combined_annot_erwinia.gff'

result_gff = []
features_test = set()

#reading file
with open (file=file_name) as f:
    
    # Initialize variables
    prev_end = 0
    seqid = None
    source = 'RefSeq'
    feature = 'intergenic'
    score = '.'
    strand = '+'
    frame = "."
    upstream_gene = None
    downstream_gene = None
    
    # Loop through each line of the file
    for line in f:
        if line.startswith('#'):
            continue
        
        # Split line into columns
        line_features = line.strip().split('\t')
        features_test.add(line_features[2])

        if line_features[2] == 'region':
            if prev_end != 0:
                result_gff.append([seqid,source, feature, prev_end, global_end, score, strand,frame,upstream_gene, downstream_gene])
            seqid = line_features[0]
            global_end = line_features[4]
            prev_end = 1
            continue

        if line_features[2] not in ['gene', 'pseudogene']:
            continue
  
        # Check if previous end coordinate exists
        if prev_end != 0:

        # Calculate intergenic region start and end coordinates
            intergenic_start = prev_end + 1
            intergenic_end = int(line_features[3]) - 1
            downstream_gene = line_features[8].split(';')[1]
            attr = f"{upstream_gene},{line_features[6]};{downstream_gene},{line_features[6]}"

            result_gff.append([seqid,source,feature,intergenic_start,intergenic_end,score, strand, frame, attr])

        # Update previous end coordinate
        prev_end = int(line_features[4])
        upstream_gene = line_features[8].split(';')[1]
        #print(line_features[8].split(';'))

with open(r'/Users/igorfesenko/test_new_ends.gff', 'w') as out:
    for i in result_gff:
        out.write(f"{i[0]}\t{i[1]}\t{i[2]}\t{i[3]}\t{i[4]}\t{i[5]}\t{i[6]}\t{i[7]}\t{i[8]}\n")
print(features_test)