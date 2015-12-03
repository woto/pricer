class AddOriginalFilenameToUpload < ActiveRecord::Migration
  def change
    add_column :uploads, :original_filename, :string
  end
end
