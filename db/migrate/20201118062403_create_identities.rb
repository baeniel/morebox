class CreateIdentities < ActiveRecord::Migration[6.0]
  def change
    create_table :identities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :uid
      t.string :provider
      t.string :access_token

      t.timestamps
    end
  end
end
