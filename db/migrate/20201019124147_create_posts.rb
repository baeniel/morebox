class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.integer :age
      t.integer :height
      t.integer :weight
      t.integer :gender
      t.integer :activity
      t.integer :work_time
      t.integer :work_count
      t.integer :target_weight
      t.string :target_date
      t.integer :lunch
      t.string :name

      t.timestamps
    end
  end
end
