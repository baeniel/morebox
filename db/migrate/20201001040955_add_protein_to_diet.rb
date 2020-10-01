class AddProteinToDiet < ActiveRecord::Migration[6.0]
  def change
    add_column :diets, :protein, :integer, default: 0
  end
end
