class AddMinQuantityToSubItems < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_items, :min_quantity, :integer
    add_column :sub_items, :order_batch, :integer
  end
end
