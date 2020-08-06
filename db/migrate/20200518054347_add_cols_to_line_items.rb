class AddColsToLineItems < ActiveRecord::Migration[6.0]
  def change
    if table_exists?(:line_items)
      add_column :line_items, :image, :string
      add_column :line_items, :title, :string
      add_column :line_items, :temp, :integer
    end
  end
end
