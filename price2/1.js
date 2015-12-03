XLSX = require('xlsx');

var wb1 = XLSX.readFile('/home/woto/aaa/xls.xls', {'cellNF': true});
var ws1 = wb1.Sheets.Sheet1;
console.log(ws1.A1);

console.log('---');

var wb2 = XLSX.readFile('/home/woto/aaa/xls.xls.xlsx', {'cellNF': true});
var ws2 = wb2.Sheets.Sheet1;
console.log(ws2.A1);
