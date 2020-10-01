class CreateDietSubItems < ActiveRecord::Migration[6.0]
  def change
    create_table :diet_sub_items do |t|
      t.references :diet, foreign_key: true
      t.references :sub_item, foreign_key: true

      t.timestamps
    end
  end
end
