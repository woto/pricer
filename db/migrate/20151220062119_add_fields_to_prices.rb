class AddFieldsToPrices < ActiveRecord::Migration
  def change
    add_column :prices, :def_c, :string
    add_column :prices, :def_b, :string
    add_column :prices, :def_n, :string
    add_column :prices, :def_p, :string
    add_column :prices, :def_d, :string
    add_column :prices, :def_q, :string
    add_column :prices, :def_01, :string
    add_column :prices, :def_02, :string
    add_column :prices, :def_03, :string
    add_column :prices, :def_04, :string
    add_column :prices, :def_05, :string
    add_column :prices, :def_06, :string
    add_column :prices, :def_07, :string
    add_column :prices, :def_c0, :string
    add_column :prices, :def_c1, :string
    add_column :prices, :def_c2, :string
    add_column :prices, :def_c3, :string
    add_column :prices, :def_c4, :string
    add_column :prices, :def_c5, :string
    add_column :prices, :def_c6, :string
    add_column :prices, :def_c7, :string
    add_column :prices, :def_c8, :string
    add_column :prices, :def_c9, :string
    add_column :prices, :def_r, :string
    add_column :prices, :def_l, :string
    add_column :prices, :def_t, :string
  end
end
