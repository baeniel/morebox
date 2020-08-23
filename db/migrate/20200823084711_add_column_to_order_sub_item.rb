class AddColumnToOrderSubItem < ActiveRecord::Migration[6.0]
  def change
    add_column :order_sub_items, :quantity, :integer
  end
end
