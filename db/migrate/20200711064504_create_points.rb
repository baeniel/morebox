class CreatePoints < ActiveRecord::Migration[6.0]
  def change
    create_table :points do |t|
      t.integer :amount
      t.integer :point_type
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
