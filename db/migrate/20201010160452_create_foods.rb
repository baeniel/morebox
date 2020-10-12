class CreateFoods < ActiveRecord::Migration[6.0]
  def change
    create_table :foods do |t|
      t.string :title
      t.text :body
      t.string :image
      t.float :kcal
      t.integer :food_type, default: 0

      t.timestamps
    end
  end
end
