class AddRemainPointToPoints < ActiveRecord::Migration[6.0]
  def change
    add_column :points, :remain_point, :integer
  end
end
