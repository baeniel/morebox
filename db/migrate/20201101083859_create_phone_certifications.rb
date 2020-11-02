class CreatePhoneCertifications < ActiveRecord::Migration[6.0]
  def change
    create_table :phone_certifications do |t|
      t.string :phone
      t.string :code
      t.integer :count, default: 0

      t.timestamps
    end
  end
end
