class CreateDiets < ActiveRecord::Migration[6.0]
  def change
    create_table :diets do |t|
      t.integer :start_calorie
      t.integer :end_calorie
      t.integer :purpose
      t.text :body
      t.boolean :snack

      t.timestamps
    end
  end
end
