class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?



  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:email, :password, :passwrd_confirmation, :phone, :remember_me, :username]
    devise_parameter_sanitizer.permit :sign_in, keys: [:phone, :password]
    devise_parameter_sanitizer.permit :account_update, keys: [:email, :password, :passwrd_confirmation, :phone, :remember_me, :username]
  end

end
