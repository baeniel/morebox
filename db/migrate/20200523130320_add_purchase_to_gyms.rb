class AddPurchaseToGyms < ActiveRecord::Migration[6.0]
  def change
    add_column :gyms, :gorilla_purchase, :integer, :default => 0
    add_column :gyms, :ultra_purchase, :integer, :default => 0
    add_column :gyms, :protein_purchase, :integer, :default => 0
  end
end
