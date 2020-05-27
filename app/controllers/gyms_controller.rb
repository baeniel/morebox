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

    #헬스장 판매 갯수 (무료 체험 제외)
    @gym_sales = @gym.orders.where.not(item: Item.first).sum(:number)

    #관리자 페이지 재고현황
    gym_stock

    #정산 (매출의 20%)
    @gym_profit = (@gym.orders.where.not(item: Item.first).map { |order| order.item.price }.sum * 0.2).to_i
  end

  private

  def gym_params
    params.require(:gym).permit(:title)
  end

  def load_object
    @gym = Gym.find params[:id]
  end
end
