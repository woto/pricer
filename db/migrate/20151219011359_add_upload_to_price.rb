class AddUploadToPrice < ActiveRecord::Migration
  def change
    add_reference :prices, :upload, index: true, foreign_key: true
  end
end
