class AddColumnsToFoods < ActiveRecord::Migration[6.0]
  def change
    add_column :foods, :carbo, :float
    add_column :foods, :protein, :float
    add_column :foods, :fat, :float
    add_column :foods, :price, :integer
  end
end
