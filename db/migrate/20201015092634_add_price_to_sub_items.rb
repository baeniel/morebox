class AddPriceToSubItems < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_items, :price, :integer
  end
end
