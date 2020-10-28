class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :name
      t.integer :weight
      t.integer :target_weight
      t.string :target_date
      t.float :morning_carbo
      t.float :morning_protein
      t.float :morning_fat
      t.float :morning_kcal
      t.float :lunch_carbo
      t.float :lunch_protein
      t.float :lunch_fat
      t.float :lunch_kcal
      t.float :dinner_carbo
      t.float :dinner_protein
      t.float :dinner_fat
      t.float :dinner_kcal
      t.float :snack_carbo
      t.float :snack_protein
      t.float :snack_fat
      t.float :snack_kcal
      t.float :ideal_kcal
      t.float :ideal_carbo
      t.float :ideal_protein
      t.float :ideal_fat
      t.string :comment

      t.timestamps
    end
  end
end
