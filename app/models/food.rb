class Food < ApplicationRecord
  mount_uploader :image, ImageUploader
  has_many :sub_items, dependent: :nullify
  enum food_type: %i(morning main snack)

end
