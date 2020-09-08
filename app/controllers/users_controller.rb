class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i(index update_referrer updating_referrer)
  skip_before_action :verify_authenticity_token, except: %i[check]

  def index
    @gym = current_user.gym
    # @gym = current_gym

    #영업 뛰어서 회원가입 시킨 사람 수
    @member_count = User.where(referrer: current_user.phone).count

    arr = []
    arr2 = []
    this_month = Date.today.month
    User.where(referrer: current_user.phone).each do |user|
      complete_orders = user.orders.complete.includes(:item)
      arr << complete_orders.map{|order| order.created_at.month.eql?(this_month) ? order.item&.price : 0 }&.sum
      arr2 << complete_orders.map{|order| order.item&.price }&.sum
    end
    #추천인 코드로 결제된 매달 결제액 (매달 갱신)
    @referrer_month_sale = arr.sum
    #그 트레이너를 통해 발생한 총 결제액 (트레이너들이 궁금할 수 있으니..)
    @referrer_total_sale = arr2.sum

    #트레이너 등수 (기준: 회원가입 많이 시킨 순으로)
    @managers = User.manager.sort_by{|user| User.where(referrer: user.phone).count }.reverse
  end

  def pay_complete
    ActionCable.server.broadcast("room_#{params[:id]}", data_type: "payment_complete") if Rails.env.development?
  end

  def update_referrer
    redirect_to list_items_path if current_user.referrer&.present?
  end

  def updating_referrer
    if params[:referrer].present? && params[:referrer]!="010"
      referer = User.manager.find_by(phone: params[:referrer])
      if referer && (referer != current_user)
        current_user.update referrer: params[:referrer]
        #추천인 코드 입력하면 1000원 무료 충전
        Point.create(user: current_user, amount: 1000, point_type: :charged)
        redirect_to list_items_path(gym: current_user.gym.id), notice: "추천인 정보가 입력되었습니다."
      else
        redirect_to update_referrer_user_path(current_user), notice: "추천인 코드가 잘못되었습니다. 확인 후 시도해주세요."
      end
    else
      current_user.update referrer: "-"
      redirect_to list_items_path(gym: current_user.gym.id)
    end
  end

  def check
    @result = (params[:phone_num].present? && (user = User.find_by(phone: params[:phone_num])))
  end
end
