class CreateSubItems < ActiveRecord::Migration[6.0]
  def change
    create_table :sub_items do |t|
      t.string :title
      t.string :image
      t.integer :point, default: 0
      t.timestamps
    end
  end
end
