class AddGymToAdminUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :admin_users, :gym, array: true, default: []
  end
end
