class RemoveTargetCalorieFromFoods < ActiveRecord::Migration[6.0]
  def change
    remove_column :foods, :target_calorie
  end
end
