class AddIsMoreboxToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :is_morebox, :integer
  end
end
