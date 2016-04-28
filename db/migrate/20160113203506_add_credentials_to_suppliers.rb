class AddCredentialsToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :username, :string
    add_column :suppliers, :password, :string
  end
end
