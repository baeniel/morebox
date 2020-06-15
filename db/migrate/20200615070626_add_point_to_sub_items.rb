class AddPointToSubItems < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_items, :point, :integer, default: 0
  end
end
