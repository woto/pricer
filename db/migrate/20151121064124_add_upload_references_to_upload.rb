class AddUploadReferencesToUpload < ActiveRecord::Migration
  def change
    add_reference :uploads, :upload, index: true, foreign_key: true
  end
end
