class AddColsToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :payment_method, :string
    add_column :orders, :order_name, :string
    add_column :orders, :order_phone, :string
    add_column :orders, :order_email, :string
    add_column :orders, :deliver_name, :string
    add_column :orders, :deliver_phone, :string
    add_column :orders, :bank, :string
    add_column :orders, :bank_owner, :string
    add_column :orders, :bank_account, :string
    add_column :orders, :requirement, :string
  end
end
