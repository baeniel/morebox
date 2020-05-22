class Changedefaultvalueforgym < ActiveRecord::Migration[6.0]
  def up
    change_column :gyms, :ultra_purchase, :integer, :default => 0, :null => false
    change_column :gyms, :gorilla_purchase, :integer, :default => 0, :null => false
    change_column :gyms, :protein_purchase, :integer, :default => 0, :null => false
  end

  def down
    change_column :gyms, :ultra_purchase, :integer
    change_column :gyms, :gorilla_purchase, :integer
    change_column :gyms, :protein_purchase, :integer
  end
end
