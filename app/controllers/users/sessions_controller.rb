# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    if params[:user].present? && User.pluck(:phone).exclude?(params[:user][:phone])
      flash[:notice] = "존재하지 않는 전화번호입니다."
    end
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

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
