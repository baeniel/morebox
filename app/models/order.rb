class Order < ApplicationRecord
  belongs_to :user

  has_many :line_items, dependent: :destroy

  enum status: [:cart, :paid, :cancled]
  scope :not_cart, -> { where.not( status: :cart ) }

  # validates :deliver_name, :deliver_phone, :zipcode, :address1, :address2, :payment_method, presence: true


end
