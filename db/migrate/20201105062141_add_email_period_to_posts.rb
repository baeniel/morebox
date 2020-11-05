class AddEmailPeriodToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :email, :string
    add_column :posts, :period, :integer
  end
end
