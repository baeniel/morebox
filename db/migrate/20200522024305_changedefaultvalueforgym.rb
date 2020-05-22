class Changedefaultvalueforgym < ActiveRecord::Migration[6.0]
  def change
    change_column_default :gyms, :ultra_purchase, :integer, default: 0
    change_column_default :gyms, :gorilla_purchase, :integer, default: 0
    change_column_default :gyms, :protein_purchase, :integer, default: 0
  end
end
