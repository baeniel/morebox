class AddDescriptionToSubItems < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_items, :description, :text
  end
end
