class GymsController < ApplicationController
  before_action :load_object, only: [:show]

  def index
  end

  def new
  end

  def create
    gym = Gym.new(gym_params)
    gym.save
    redirect_to gym_path(gym), notice: "헬스장이 등록되었습니다."
  end

  def show
    @fit_center = @gym.users.find_by(fit_center: true)

    #헬스장 무료 체험
    arr = []
    @gym.orders.where(item: Item.first, number: 1).each do |order|
      if order.created_at.month == Date.today.month
        arr << order
      end
    end

    @gym_free_month = arr.group_by { |arr| arr[:user_id] }.count
    @gym_free = @gym.orders.where(item: Item.first, number: 1).group(:item_id, :user_id).size.count

    #헬스장 판매 갯수 (총 판매 - 무료 체험)
    @gym_sales = @gym.orders.sum(:number) - @gym_free

    #관리자 페이지 재고현황
    # gym_stock

    #정산 (매출의 20%)
    @gym_profit = ((@gym.orders.map { |order| order.created_at.month == Date.today.month ? order.item.price : 0 }.sum - @gym_free_month * Item.first.price) * 0.2).to_i

    #재고 표시 관련 코드
    @sub_items = @gym.sub_items.order(:created_at).map { |sub_item| sub_item.title }

    stocks = [@gym.gorilla_stock, @gym.ultra_stock, @gym.protein_stock, @gym.stock_1, @gym.stock_2, @gym.stock_3, @gym.stock_4]
    @stock_arr = []
    stocks.each do |stock|
      unless stock == 0
        @stock_arr << stock
      end
    end

  end

  private

  def gym_params
    params.require(:gym).permit(:title)
  end

  def load_object
    @gym = Gym.find params[:id]
  end
end
