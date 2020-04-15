class Order < ApplicationRecord
  belongs_to :user, optional: true

  has_many :line_items, dependent: :destroy

  enum status: [:cart, :paid, :cancled]

  validates :deliver_name, :deliver_phone, :zipcode, :address1, :address2, :payment_method, presence: true


end
