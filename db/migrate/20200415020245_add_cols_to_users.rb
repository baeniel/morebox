class AddColsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :payment, :boolean
    add_column :users, :phone, :string
    add_column :users, :username, :string
    add_column :users, :fit_center, :boolean
  end
end
