class AddNutritionsToSubItems < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_items, :calorie, :integer
    add_column :sub_items, :carbo, :integer
    add_column :sub_items, :protein, :integer
    add_column :sub_items, :fat, :integer
  end
end
