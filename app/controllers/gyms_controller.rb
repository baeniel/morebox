class GymsController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :load_object, only: [:show]
  before_action :check_auth, only: [:show]
  before_action :check_admin_user, only: [:index, :total_dashboard]

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

    #재결제율 분모 (2주간 잔여 포인트가 1500 미만 && 최초 결제 건 이후의 사건이어야 함)
    poors = []
    Point.where(created_at: date_end..date_start, point_type: 1).where("remain_point < ?", 1500).each do |point|
      complete_order = point.user.orders.complete.first
      if complete_order.present? && (complete_order.created_at < point.created_at)
        poors << point.user.id
      end
    end

    #같은 기간동안 실제 결제 건의 개수
    repayment = []
    Order.complete.where(created_at: date_end..date_start).each do |order|
      if poors.include?(order.user.id)
        repayment << order.user.id
      end
    end
    #재결제율 분자 (분모와 분자 교집합)
    @repayment_rate = (repayment.uniq.count.to_f / poors.count.to_f) * 100

    #지점 당 일평균 매출
    daily_profit = []
    Gym.all.order(:created_at).each do |gym|
      if (Date.today - gym.created_at.to_date).to_i >= 14
        daily_profit << (gym.orders.where(created_at: date_end..date_start, status: 1).map { |order| order&.item&.price.to_i }.sum / 14)
      elsif (Date.today - gym.created_at.to_date).to_i == 0
        daily_profit << (gym.box_sale / 1)
      else
        daily_profit << (gym.box_sale / (Date.today - gym.created_at.to_date).to_i)
      end
    end
    @gym_daily_profit = daily_profit.sum(0.0) / daily_profit.size


    # 결제실패율 공식
    # users = []
    # first_denominator = Order.complete.where(created_at: Date.parse("2020-10-07").beginning_of_day..Date.parse("2020-10-08").beginning_of_day).count
    # Order.ready.where(created_at: Date.parse("2020-10-07").beginning_of_day..Date.parse("2020-10-08").beginning_of_day).each do |order|
    #   if order.user.orders.where(created_at: Date.parse("2020-10-07").beginning_of_day..Date.parse("2020-10-08").beginning_of_day).none? { |order| order.complete? }
    #     users << order.user
    #   end
    # end
    # second_denominator = users.uniq.count
    # order_fail_rate = (second_denominator / (first_denominator + second_denominator).to_f) * 100
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

    #정산 (모어박스 매출의 20%, 매월 갱신)
    if @gym.title == "모던복싱" or @gym.title == "에이짐휘트니스"
      @founder_commission = (@gym.month_box_sale * 0.3).to_i
    elsif @gym.title == "퀸즈바디야탑" or @gym.title == "요가룩스강동역점"
      @founder_commission = (@gym.month_box_sale * 0.25).to_i
    else
      @founder_commission = (@gym.month_box_sale * 0.2).to_i
    end
  end

  def total_dashboard ;end

  private

  def gym_params
    params.require(:gym).permit(:title)
  end

  def load_object
    @gym = Gym.find params[:id]
  end

  def check_auth
    redirect_to root_path, notice: "접근권한이 없습니다." unless current_user.fit_center && (current_user.gym == @gym)
  end

  def check_admin_user
    redirect_to root_path unless current_admin_user
  end

end
