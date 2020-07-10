class ChangeDefaultvalueForPayment < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :payment, from: true, to: false
  end
end
