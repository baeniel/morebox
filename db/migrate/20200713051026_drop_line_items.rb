class DropLineItems < ActiveRecord::Migration[6.0]
  def change
    drop_table :line_items
  end
end
