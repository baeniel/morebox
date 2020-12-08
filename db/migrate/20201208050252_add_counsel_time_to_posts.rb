class AddCounselTimeToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :counsel_time, :integer
  end
end
