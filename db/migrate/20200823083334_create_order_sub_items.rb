class CreateOrderSubItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_sub_items do |t|
      t.references :order, foreign_key: true
      t.references :sub_item, foreign_key: true

      t.timestamps
    end
  end
end
