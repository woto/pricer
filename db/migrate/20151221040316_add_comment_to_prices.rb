class AddCommentToPrices < ActiveRecord::Migration
  def change
    add_column :prices, :comment, :string
  end
end
