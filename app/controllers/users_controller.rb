class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i(index update_referrer updating_referrer market)
  skip_before_action :verify_authenticity_token, except: %i[check]

  def index
    @gym = current_user.gym
    # @gym = current_gym
    calculating_trainer_sale
    #트레이너 등수 (기준: 회원가입 많이 시킨 순으로)
    # @managers = User.manager.sort_by{|user| User.where(referrer: user.phone).count }.reverse
  end

  def market
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
