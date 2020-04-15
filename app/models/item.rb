class Item < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :line_items, dependent: :destroy

  def image_url
    image.url.present? ? image.url(:square) : '/logo 2.png'
  end
end
