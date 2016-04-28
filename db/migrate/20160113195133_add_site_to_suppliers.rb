class AddSiteToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :site, :string
  end
end
