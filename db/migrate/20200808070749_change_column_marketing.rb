class ChangeColumnMarketing < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :marketing, :integer
    add_column :users, :marketing, :boolean, default: 1
  end
end
