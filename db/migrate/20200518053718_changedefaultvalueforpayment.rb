class Changedefaultvalueforpayment < ActiveRecord::Migration[6.0]
  def up
    change_column_default :users, :payment, true
  end

  def down
    change_column_default :users, :payment, false
  end
end
