class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :title
      t.text :notes

      t.timestamps null: false
    end
  end
end
