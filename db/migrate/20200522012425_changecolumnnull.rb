class Changecolumnnull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :item_id, true
  end
end
