class AddPythonSnifferResultToUpload < ActiveRecord::Migration
  def change
    add_column :uploads, :python_sniffer_result, :text
  end
end
