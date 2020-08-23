class OrderSubItem < ApplicationRecord
  belongs_to :order
  belongs_to :sub_item
end
