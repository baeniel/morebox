class ChangeColumnTypePhone < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :phone, :string
  end
end
