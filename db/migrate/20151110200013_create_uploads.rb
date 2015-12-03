class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :price
      t.integer :job_type
      t.string :content_type
      t.integer :file_size
      t.string :wc
      t.integer :tasks_counter
      t.text :notes
      t.text :command

      t.timestamps null: false
    end
  end
end
