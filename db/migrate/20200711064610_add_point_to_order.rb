class AddPointToOrder < ActiveRecord::Migration[6.0]
  def change
    rename_column :orders, :point, :before_point
    add_reference :orders, :point, foreign_key: true
  end
end
