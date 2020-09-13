class ChangeDatatypes < ActiveRecord::Migration[6.0]
  def change
    change_column :sub_items, :calorie, :float
    change_column :sub_items, :carbo, :float
    change_column :sub_items, :protein, :float
    change_column :sub_items, :fat, :float
  end
end
