class Gym < ApplicationRecord
  has_many :users, dependent: :destroy

  has_many :orders, dependent: :destroy
  has_many :line_items, through: :orders

  has_many :gyms_sub_items
  has_many :sub_items, through: :gyms_sub_items
  # has_and_belongs_to_many :sub_items, join_table: :gyms_sub_items
  accepts_nested_attributes_for :sub_items
end
