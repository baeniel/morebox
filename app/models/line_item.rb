class LineItem < ApplicationRecord
  # 모어박스 쇼핑몰 형태
  # belongs_to :order
  # belongs_to :item
  #################

  mount_uploader :image, ImageUploader

  belongs_to :order
  # belongs_to :sub_item
  # belongs_to :gym

  def image_url
    image.url.present? ? image.url(:square) : '/logo.png'
  end
end
