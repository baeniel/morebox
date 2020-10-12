class AddTargetKcalToFood < ActiveRecord::Migration[6.0]
  def change
    add_column :foods, :target_calorie, :float
  end
end
