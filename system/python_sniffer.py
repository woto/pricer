import csv, sys, json, tempfile, pdb, operator, time

with open(sys.argv[1], 'r') as csvfile:
    # csv.field_size_limit(sys.maxsize)
    csv.field_size_limit(sys.maxsize)
    quoting_modes = dict( (getattr(csv,n), n) for n in dir(csv) if n.startswith('QUOTE_') )
    delimiters = ['\t', ';', ',']
    columns_stats = {}
    while True:
        dialect = csv.Sniffer().sniff(csvfile.read(10240), delimiters)
        csvfile.seek(0)
        reader = csv.reader( (line.replace('\0','') for line in csvfile), dialect )
        for row in reader:
            row_len = len(row)
            columns_stats.setdefault(row_len, 0)
            columns_stats[row_len] += 1
        if bool(columns_stats):
            max_columns_occurencies = max(columns_stats.items(), key=operator.itemgetter(1))[0]
            csvfile.seek(0)
            if max_columns_occurencies < 3:
                delimiters.remove(dialect.delimiter)
                time.sleep(1)
            else:
                break
        else:
            break

    print(json.dumps({
      'delimiter': dialect.delimiter,
      'skipinitialspace': dialect.skipinitialspace,
      'doublequote': dialect.doublequote,
      'quoting_mode': quoting_modes[dialect.quoting],
      'quotechar': dialect.quotechar,
      'lineterminator': dialect.lineterminator,
      'escapechar': dialect.escapechar
      }))

    #reader = csv.reader(csvfile, dialect)
    reader = csv.reader( (line.replace('\0','') for line in csvfile), dialect )
    with open(sys.argv[2], 'w') as csvfile:
        csv_writer = csv.writer(csvfile)
        for row in reader:
            csv_writer.writerow(row)
