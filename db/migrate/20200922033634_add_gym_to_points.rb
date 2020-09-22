class AddGymToPoints < ActiveRecord::Migration[6.0]
  def change
    add_reference :points, :gym, foreign_key: true
  end
end
