class AddCountToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :count, :integer
  end
end
