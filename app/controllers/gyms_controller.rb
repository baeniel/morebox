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

    #헬스장의 총 판매 갯수 (정확한 재고 파악을 위해 무료로 하나 가져가는 것 포함)
    @gym_sales = @gym.orders.sum(:number)

    #관리자 페이지 재고현황
    gym_stock

    #정산 (매출의 20%)
    @gym_profit = (@ m * 0.2).to_i
  end

  private

  def gym_params
    params.require(:gym).permit(:title)
  end

  def load_object
    @gym = Gym.find params[:id]
  end
end
