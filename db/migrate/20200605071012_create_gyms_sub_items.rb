class CreateGymsSubItems < ActiveRecord::Migration[6.0]
  def change
    create_table :gyms_sub_items do |t|
      t.integer :gym_id
      t.integer :sub_item_id

      t.timestamps
    end
  end
end
