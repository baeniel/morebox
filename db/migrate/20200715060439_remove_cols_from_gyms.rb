class RemoveColsFromGyms < ActiveRecord::Migration[6.0]
  def change
    remove_columns :gyms, :gorilla_stock, :ultra_stock, :protein_stock, :gorilla_purchase, :ultra_purchase, :protein_purchase, :purchase_1, :purchase_2, :purchase_3, :purchase_4, :stock_1, :stock_2, :stock_3, :stock_4
  end
end
