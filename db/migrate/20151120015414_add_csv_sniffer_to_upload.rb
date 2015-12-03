class AddCsvSnifferToUpload < ActiveRecord::Migration
  def change
    add_column :uploads, :csv_sniffer, :string
  end
end
