class AddCategoryToSubItems < ActiveRecord::Migration[6.0]
  def change
    add_reference :sub_items, :category, null: true, foreign_key: true
  end
end
