class DropLineItems < ActiveRecord::Migration[6.0]
  def change
    if table_exists?(:line_items)
      drop_table :line_items
    end
  end
end
