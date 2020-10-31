class CreatePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :purchases do |t|
      t.references :gym, foreign_key: true
      t.references :sub_item, foreign_key: true
      t.integer :quantity, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
