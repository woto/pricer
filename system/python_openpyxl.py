import openpyxl, sys, csv, pdb

wb = openpyxl.load_workbook(sys.argv[1])
sh = wb.get_active_sheet()
with open('test.csv', 'wb') as f:
    c = csv.writer(f)
    for r in sh.rows:
        pdb.set_trace()
        c.writerow([cell.value for cell in r])
