class AddIsCounseledToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :is_counseled, :boolean, default: 0
  end
end
