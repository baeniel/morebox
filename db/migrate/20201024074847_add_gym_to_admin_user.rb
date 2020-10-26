class AddGymToAdminUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :admin_users, :gym, foreign_key: true
  end
end
