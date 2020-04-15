class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :number
      t.integer :total
      t.integer :status
      t.string :address1
      t.string :address2
      t.string :zipcode

      t.timestamps
    end
  end
end
