class AddCsvSnifferResultToUpload < ActiveRecord::Migration
  def change
    add_column :uploads, :csv_sniffer_result, :text
  end
end
