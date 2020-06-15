class AddPointToLineItems < ActiveRecord::Migration[6.0]
  def change
    add_column :line_items, :point, :integer, default: 0
  end
end
