class Gym < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :points

  has_many :orders, dependent: :destroy
  has_many :line_items, through: :orders

  has_many :gyms_sub_items, dependent: :destroy
  has_many :sub_items, through: :gyms_sub_items
  # has_and_belongs_to_many :sub_items, join_table: :gyms_sub_items
  accepts_nested_attributes_for :sub_items

  #지금까지 모어박스 총 매출
  def box_sale
    self.orders.complete.map{|order| order.payment_amount.to_i }&.sum
  end

  #이번 달 모어박스 매출
  def month_box_sale
    this_month = Date.today.month
    self.orders.complete.map{|order| order.created_at.month.eql?(this_month) ? order&.payment_amount.to_i : 0 }&.sum
  end

  #이번 달 그 센터의 총 매출 => 추후 모어마켓에서 트레이너 코드 쓴 매출 포함시켜야 함.
  def month_center_sale
    this_month = Date.today.month
    month_market_sale = 0
    self.orders.complete.map{|order| order.created_at.month.eql?(this_month) ? order&.payment_amount.to_i : 0 }&.sum + month_market_sale
    # self.orders.complete.includes(:item).map{|order| order.created_at.month.eql?(this_month) ? order&.item&.price.to_i : 0 }&.sum + month_market_sale
  end
end
