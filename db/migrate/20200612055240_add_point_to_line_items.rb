class AddPointToLineItems < ActiveRecord::Migration[6.0]
  def change
    if table_exists?(:line_items)
      add_column :line_items, :point, :integer, default: 0
    end
  end
end
