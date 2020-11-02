# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    if params[:user].present? && User.pluck(:phone).exclude?(params.dig(:user, :phone))
      # flash[:notice] = "존재하지 않는 전화번호입니다."
      flash[:notice] = "회원가입이 필요합니다."
      redirect_to new_user_registration_path(phone: params.dig(:user, :phone))
    else
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      yield resource if block_given?
      respond_with(resource, serialize_options(resource))
    end
  end

  # POST /resource/sign_in
  def create
    cookies[:gym_id] = params.dig(:user, :gym_id)
    if (user = User.find_by phone: params.dig(:user, :phone))
      sign_in user
      redirect_to after_sign_in_path_for(user)
    else
      super
    end


  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
