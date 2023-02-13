def parse_gff_file(file_path):
    gff_features = []
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith('#'):
                continue
            fields = line.strip().split('\t')
            seqid = fields[0]
            source = fields[1]
            feature_type = fields[2]
            start = int(fields[3])
            end = int(fields[4])
            score = fields[5]
            strand = fields[6]
            phase = fields[7]
            attribute_string = fields[8]
            attributes = {}
            for attr in attribute_string.split(';'):
                key, value = attr.strip().split('=')
                attributes[key] = value
            gff_features.append({
                'seqid': seqid,
                'source': source,
                'feature_type': feature_type,
                'start': start,
                'end': end,
                'score': score,
                'strand': strand,
                'phase': phase,
                'attributes': attributes
            })
    return gff_features

gff_file = '/path/to/your/gff/file.gff'
gff_features = parse_gff_file(gff_file)
print(gff_features)
