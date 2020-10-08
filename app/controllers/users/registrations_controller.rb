# frozen_string_literal: true
require "browser"

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    build_resource
    yield resource if block_given?
    resource&.gym_id = cookies[:gym_id]
    @phone_num = params[:phone]
    respond_with resource
  end

  # POST /resource
  def create
    email = SecureRandom.alphanumeric(5)+"@com"
    while User.find_by(email: email)
      email = SecureRandom.alphanumeric(5)+"@com"
    end
    params[:user][:email] = email
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    # super(resource)
    unless ["스프링타운2층", "짐박스3호점", "얼티밋크로스핏", "테라피티(언주)", "에이짐휘트니스", "모던복싱", "FM피트니스", "짐박스난곡점"].include? current_user.gym.title
      if current_user.gym.title == "팀레드"
        Point.create(amount: 2500, point_type: :charged, user: current_user)
      else
        Point.create(amount: 1000, point_type: :charged, user: current_user)
      end
    end
    browser = Browser.new(request.env["HTTP_USER_AGENT"])
    browser.device.tablet? ? list_items_path : market_users_path
  end
  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
