class ChangeColumnsOfPosts < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :height, :float
    change_column :posts, :weight, :float
    change_column :posts, :target_weight, :float
  end
end
