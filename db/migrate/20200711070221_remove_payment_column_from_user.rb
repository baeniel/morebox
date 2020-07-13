class RemovePaymentColumnFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :payment
    remove_reference :users, :item
  end
end
