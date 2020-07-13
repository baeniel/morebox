class AddSubItemToPoint < ActiveRecord::Migration[6.0]
  def change
    add_reference :points, :sub_item, foreign_key: true
  end
end
