class GymsController < ApplicationController
  before_action :load_object, only: [:show]

  def index
    #지난 2주간 가입한 신규 유저 수
    date_start = DateTime.now
    date_end = date_start - 14.days
    users = User.where(created_at: date_end..date_start)

    #그 유저들 중에서 결제한 사람의 수
    payment_users = []
    users.each do |user|
      if user.orders.count != 0
        payment_users << 1
      end
    end

    #결제전환율
    @payment_rate = (payment_users.count.to_f / users.count.to_f) * 100

    #재결제율 분모 (2주간 잔여 포인트가 1500 미만이었던 건의 개수)
    poors = Point.where(created_at: date_end..date_start, point_type: 1).where("remain_point < ?", 1500).count
    #그 포인트의 주인
    user_poors = []
    Point.where(created_at: date_end..date_start, point_type: 1).where("remain_point < ?", 1500).each do |point|
      user_poors << point.user.id
    end
    #같은 기간동안 charged 건의 개수
    user_charges = []
    Point.where(created_at: date_end..date_start, point_type: 0).each do |point|
      user_charges << point.user.id
    end
    #재결제율 분자 (분모와 분자 교집합)
    repayment = (user_poors & user_charges).count
    @repayment_rate = (repayment.to_f / poors.to_f) * 100

    #지점 당 일평균 매출
    daily_profit = []
    Gym.all.order(:created_at).each do |gym|
      if (Date.today - gym.created_at.to_date).to_i >= 14
        daily_profit << (gym.orders.where(created_at: date_end..date_start, status: 1).map { |order| order&.item&.price.to_i }.sum / 14)
      elsif (Date.today - gym.created_at.to_date).to_i == 0
        daily_profit << (gym.orders.where(status: 1).map { |order| order&.item&.price.to_i }.sum / 1)
      else
        daily_profit << (gym.orders.where(status: 1).map { |order| order&.item&.price.to_i }.sum / (Date.today - gym.created_at.to_date).to_i)
      end
    end
    @gym_daily_profit = daily_profit.sum(0.0) / daily_profit.size
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
    if @gym.title == "모던복싱" or @gym.title == "에이짐휘트니스"
      @gym_profit = (@gym.orders.where(status: 1).map { |order| order.created_at.month == Date.today.month ? order&.item&.price.to_i : 0 }.sum * 0.3).to_i
    else
      @gym_profit = (@gym.orders.where(status: 1).map { |order| order&.created_at&.month == Date.today.month ? order&.item&.price.to_i : 0 }.sum * 0.2).to_i
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
