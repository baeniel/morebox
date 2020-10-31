class RemoveGymFromAdminUser < ActiveRecord::Migration[6.0]
  def change
    remove_reference :admin_users, :gym
  end
end
