class AddTrainerToOrder < ActiveRecord::Migration[6.0]
  def change
    add_reference :orders, :trainer, foreign_key: { to_table: :users }
  end
end
