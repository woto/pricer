import csv, sys, json, tempfile, pdb

with open(sys.argv[1], 'r') as csvfile:
    # csv.field_size_limit(sys.maxsize)
    csv.field_size_limit(sys.maxsize)
    dialect = csv.Sniffer().sniff(csvfile.read(10240))
    csvfile.seek(0)

    quoting_modes = dict( (getattr(csv,n), n) for n in dir(csv) if n.startswith('QUOTE_') )
    
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
