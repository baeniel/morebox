class AddOrderTypeToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :order_type, :integer, default: 0
  end
end
