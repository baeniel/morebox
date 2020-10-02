class AddLinkToSubItem < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_items, :link, :string
  end
end
