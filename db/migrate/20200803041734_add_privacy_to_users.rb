class AddPrivacyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :privacy, :boolean, default: 1
  end
end
