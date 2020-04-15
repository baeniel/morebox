class CreateLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :line_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :quantity
      t.integer :price

      t.timestamps
    end
  end
end
