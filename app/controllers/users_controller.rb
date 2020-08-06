class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i(update_referrer updating_referrer)
  skip_before_action :verify_authenticity_token
  # def pay
  #   user = User.find_by(phone: params[:phone])
  #   if user
  #     sign_in(user)
  #   else
  #     redirect_to new_session_path, notice: "로그인이 필요한 서비스입니다."
  #   end
  # end

  def pay_complete
  end

  def update_referrer
    redirect_to list_items_path if current_user.referrer&.present?
  end

  def updating_referrer
    if params[:referrer].present?
      #TODO
      # 유저 타입 추가되면, 메니저 타입의 유저만 지급해야함.
      referer = User.find_by(phone: params[:referrer])
      if referer && (referer != current_user)
        current_user.update referrer: params[:referrer]
        redirect_to list_items_path, notice: "추천인 정보가 입력되었습니다."
      else
        redirect_to update_referrer_user_path(current_user), notice: "추천인 코드가 잘못되었습니다. 확인 후 시도해주세요."
      end
    else
      current_user.update referrer: "-"
      redirect_to list_items_path
    end
  end

end
