class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string :title
      t.references :supplier, index: true, foreign_key: true
      t.datetime :imported_at

      100.times do |i|
        t.string "field_#{i}"
      end

      t.timestamps null: false
    end
  end
end
