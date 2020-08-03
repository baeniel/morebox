class AddMarketingToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :marketing, :integer
  end
end
