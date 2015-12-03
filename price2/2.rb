require 'roo'
require 'roo-xls'

xlsx = Roo::Spreadsheet.open('/home/woto/rails/pricer/public/uploads/upload/price/107/PriceToyotaOpt__1_.xlsx')
puts xlsx.info

# Use the extension option if the extension is ambiguous.
#xlsx = Roo::Spreadsheet.open('./rails_temp_upload', extension: :xlsx)
