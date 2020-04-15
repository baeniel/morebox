class Order < ApplicationRecord
  belongs_to :user, optional: true

  has_many :line_items, dependent: :destroy

  enum status: [:cart, :paid, :cancled]
end
