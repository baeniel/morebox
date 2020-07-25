class UsersController < ApplicationController
  # skip_before_action :verify_authenticity_token
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
end
