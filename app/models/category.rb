class Category < ApplicationRecord
  has_many :sub_items, dependent: :nullify
end
