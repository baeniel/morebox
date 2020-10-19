class Order < ApplicationRecord
  # 모어박스 쇼핑몰 형태
  # belongs_to :user
  # has_many :line_items, dependent: :destroy
  # enum status: [:cart, :paid, :cancled]
  # scope :not_cart, -> { where.not( status: :cart ) }
  ####################

  belongs_to :user, optional: true
  belongs_to :item, optional: true
  belongs_to :trainer, optional: true, class_name: "User"
  belongs_to :gym, optional: true
  belongs_to :point, optional: true

  has_many :order_sub_items, dependent: :destroy
  has_many :sub_items, through: :order_sub_items

  enum status: %i(ready complete incomplete)
  enum order_type: %i(morebox survey)

  validates :order_name, presence: true
  validates :order_phone, presence: true
  validates :deliver_name, presence: true
  validates :deliver_phone, presence: true
  validates :zipcode, presence: true
  validates :address1, presence: true
  validates :address2, presence: true
  validates :order_number, presence: true, uniqueness: true

  accepts_nested_attributes_for :order_sub_items, reject_if: ->(attributes){ attributes['sub_item_id'].blank? || attributes['quantity'].blank? }, allow_destroy: true
  # has_many :line_items, dependent: :destroy
  # has_many :sub_items, through: :line_items
  # validates :deliver_name, :deliver_phone, :zipcode, :address1, :address2, :payment_method, presence: true
end
