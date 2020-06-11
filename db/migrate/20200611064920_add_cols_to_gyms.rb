class AddColsToGyms < ActiveRecord::Migration[6.0]
  def change
    add_column :gyms, :purchase_1, :integer, default: 0
    add_column :gyms, :purchase_2, :integer, default: 0
    add_column :gyms, :purchase_3, :integer, default: 0
    add_column :gyms, :purchase_4, :integer, default: 0
    add_column :gyms, :stock_1, :integer, default: 0
    add_column :gyms, :stock_2, :integer, default: 0
    add_column :gyms, :stock_3, :integer, default: 0
    add_column :gyms, :stock_4, :integer, default: 0
  end
end
