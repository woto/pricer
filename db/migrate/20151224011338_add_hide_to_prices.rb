class AddHideToPrices < ActiveRecord::Migration
  def change
    add_column :prices, :hide, :boolean, default: false
  end
end
