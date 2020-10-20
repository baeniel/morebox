class FoodSubItem < ApplicationRecord
  belongs_to :food, optional: true
  belongs_to :sub_item, optional: true
end
