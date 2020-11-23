class AddPaymentToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :payment, :integer, default: false
  end
end
