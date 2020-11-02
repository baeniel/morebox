class Purchase < ApplicationRecord
  belongs_to :gym
  belongs_to :sub_item

  enum status: %i(before done)
end
