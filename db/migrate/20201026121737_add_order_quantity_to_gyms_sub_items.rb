class AddOrderQuantityToGymsSubItems < ActiveRecord::Migration[6.0]
  def change
    add_column :gyms_sub_items, :order_quantity, :integer, default: 0
  end
end
