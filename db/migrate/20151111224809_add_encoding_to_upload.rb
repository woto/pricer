class AddEncodingToUpload < ActiveRecord::Migration
  def change
    add_column :uploads, :encoding, :string
  end
end
