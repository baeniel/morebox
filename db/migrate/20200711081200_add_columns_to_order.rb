class AddColumnsToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :paid_at, :datetime
    add_column :orders, :payment_amount, :integer
    add_column :orders, :tid, :string
  end
end
