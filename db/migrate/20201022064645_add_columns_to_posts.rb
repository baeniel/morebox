class AddColumnsToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :work_strength, :integer
    add_column :posts, :sickness, :string
  end
end
