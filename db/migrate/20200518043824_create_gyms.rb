class CreateGyms < ActiveRecord::Migration[6.0]
  def change
    create_table :gyms do |t|
      t.string :title
      t.integer :gorilla_purchase
      t.integer :ultra_purchase
      t.integer :protein_purchase

      t.timestamps
    end
  end
end
