class RemoveItemPriceFromLineItems < ActiveRecord::Migration[6.0]
  def change
    if table_exists?(:line_items)
      remove_column :line_items, :item_id
      remove_column :line_items, :price
    end
  end
end
