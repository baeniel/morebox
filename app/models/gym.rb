class Gym < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :points, through: :users

  has_many :orders, dependent: :destroy
  has_many :line_items, through: :orders

  has_many :gyms_sub_items, dependent: :destroy
  has_many :sub_items, through: :gyms_sub_items
  # has_and_belongs_to_many :sub_items, join_table: :gyms_sub_items
  accepts_nested_attributes_for :sub_items

  def gym_profit
    self.orders&.where(status: 1)&.map { |order| order&.item&.price.to_i }&.sum
  end

  def month_gym_profit
    self.orders&.where(status: 1)&.map { |order| order&.created_at&.month == Date.today.month ? order&.item&.price.to_i : 0 }&.sum
  end
end
