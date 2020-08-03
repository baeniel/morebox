class GymsController < ApplicationController
  before_action :load_object, only: [:show]

  def index
    #지난 2주간 가입한 신규 유저 수
    @date_start = DateTime.now
    @date_end = @date_start - 14.days
    @users = User.where(created_at: @date_end..@date_start)

    #그 유저들 중에서 결제한 사람의 수
    payment_users = []
    @users.each do |user|
      if user.orders.count != 0
        payment_users << 1
      end
    end

    #결제전환율
    @payment_rate = (payment_users.count.to_f / @users.count.to_f) * 100

    #지난 2주간 포인트가 적었던 사람 수
    poor = []
    User.all.each do |user|
      if user.remained_point < 1500
        poor << user.id
      end
    end

    #지점 당 일평균 매출

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
    if @gym.title == "모던복싱"
      @gym_profit = (@gym.orders.where(status: 1).map { |order| order.created_at.month == Date.today.month ? order.item.price : 0 }.sum * 0.3).to_i
    else
      @gym_profit = (@gym.orders.where(status: 1).map { |order| order.created_at.month == Date.today.month ? order.item.price : 0 }.sum * 0.2).to_i
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
