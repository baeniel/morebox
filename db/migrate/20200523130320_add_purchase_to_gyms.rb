class AddPurchaseToGyms < ActiveRecord::Migration[6.0]
  def change
    add_column :gyms, :gorilla_purchase, :integer, :default => 40
    add_column :gyms, :ultra_purchase, :integer, :default => 48
    add_column :gyms, :protein_purchase, :integer, :default => 40
  end
end
