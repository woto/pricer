class AddManagerFieldsToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :manager_name, :string
    add_column :suppliers, :manager_phone, :string
    add_column :suppliers, :manager_email, :string
  end
end
