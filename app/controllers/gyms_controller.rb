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
    # arr = []
    # @gym.orders.where(item: Item.first, number: 1).each do |order|
    #   if order.created_at.month == Date.today.month
    #     arr << order
    #   end
    # end
    #
    # @gym_free_month = arr.group_by { |arr| arr[:user_id] }.count
    # @gym_free = @gym.orders.where(item: Item.first, number: 1).group(:item_id, :user_id).size.count

    #헬스장 판매 갯수 (매월 갱신)
    @gym_sales = @gym.points.where(point_type: 1).map { |point| point.created_at.month == Date.today.month ? 1 : 0}.sum

    #정산 (매출의 20%, 매월 갱신)
    @gym_profit = (@gym.orders.where(status: 1).map { |order| order.created_at.month == Date.today.month ? order.item.price : 0 }.sum * 0.2).to_i
  end

  private

  def gym_params
    params.require(:gym).permit(:title)
  end

  def load_object
    @gym = Gym.find params[:id]
  end
end
