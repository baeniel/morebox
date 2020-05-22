class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :gyms, :gorilla_purchase, :gorilla_stock
    rename_column :gyms, :ultra_purchase, :ultra_stock
    rename_column :gyms, :protein_purchase, :protein_stock
  end
end
