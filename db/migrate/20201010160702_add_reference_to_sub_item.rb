class AddReferenceToSubItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :sub_items, :food, foreign_key: true
    add_column :sub_items, :sub_item_type, :integer, default: 0
  end
end
