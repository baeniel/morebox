class CreateCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cards do |t|
      t.text :description
      t.integer :importance
      t.integer :category

      t.timestamps
    end
  end
end
