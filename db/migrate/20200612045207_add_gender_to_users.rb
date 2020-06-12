class AddGenderToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :gender, :integer, null: true
  end
end
