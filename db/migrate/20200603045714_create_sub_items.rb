class CreateSubItems < ActiveRecord::Migration[6.0]
  def change
    create_table :sub_items do |t|
      t.string :title
      t.string :image
      t.timestamps
    end
  end
end
