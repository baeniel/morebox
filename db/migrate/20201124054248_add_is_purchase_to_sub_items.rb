class AddIsPurchaseToSubItems < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_items, :is_purchase, :integer, default: false
  end
end
