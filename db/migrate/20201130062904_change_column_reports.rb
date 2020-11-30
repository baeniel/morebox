class ChangeColumnReports < ActiveRecord::Migration[6.0]
  def change
    change_column :reports, :weight, :decimal
    change_column :reports, :target_weight, :decimal
  end
end
