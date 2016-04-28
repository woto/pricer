class AddNotesInvisibleToPrices < ActiveRecord::Migration
  def change
    add_column :prices, :notes_invisible, :text
  end
end
