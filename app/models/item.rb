class Item < ApplicationRecord
  mount_uploader :image, ImageUploader
  mount_uploader :image2, ImageUploader

  has_many :line_items, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :users, dependent: :nullify

  def image_url
    image.url.present? ? image.url(:square) : '/logo 2.png'
  end
end
