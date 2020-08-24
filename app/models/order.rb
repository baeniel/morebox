class Order < ApplicationRecord
  # 모어박스 쇼핑몰 형태
  # belongs_to :user
  # has_many :line_items, dependent: :destroy
  # enum status: [:cart, :paid, :cancled]
  # scope :not_cart, -> { where.not( status: :cart ) }
  ####################

  belongs_to :user
  belongs_to :item, optional: true
  belongs_to :gym, optional: true
  belongs_to :point, optional: true
  has_many :order_sub_items, dependent: :destroy
  has_many :sub_items, through: :order_sub_items

  enum status: %i(ready complete fail)
  # has_many :line_items, dependent: :destroy
  # has_many :sub_items, through: :line_items
  # validates :deliver_name, :deliver_phone, :zipcode, :address1, :address2, :payment_method, presence: true
end
