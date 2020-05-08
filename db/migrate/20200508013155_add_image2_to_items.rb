class AddImage2ToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :image2, :string
  end
end
