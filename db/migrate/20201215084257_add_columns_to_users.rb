class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :target_weight, :decimal
    add_column :users, :target_date, :string
    add_column :users, :ideal_kcal, :float
    add_column :users, :ideal_carbo, :float
    add_column :users, :ideal_protein, :float
    add_column :users, :ideal_fat, :float
  end
end
