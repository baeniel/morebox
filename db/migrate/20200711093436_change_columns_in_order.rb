class ChangeColumnsInOrder < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :gym_id, :bigint, null: true
    change_column :orders, :item_id, :bigint, null: true

  end
end
