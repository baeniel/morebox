class CreateFoodSubItems < ActiveRecord::Migration[6.0]
  def change
    drop_table :food_subitems if table_exists? :food_subitems
    create_table :food_sub_items do |t|
      t.references :food, foreign_key: true
      t.references :sub_item, foreign_key: true

      t.timestamps
    end
  end
end
