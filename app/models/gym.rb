class Gym < ApplicationRecord
  has_many :users, dependent: :nullify
end
