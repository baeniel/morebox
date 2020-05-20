class Gym < ApplicationRecord
  has_many :users, dependent: :nullify

  has_many :orders, dependent: :destroy
  has_many :line_items, through: :orders
end
