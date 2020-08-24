class ApplicationController < ActionController::Base
  #모어박스 쇼핑몰 형태
  # before_action :configure_permitted_parameters, if: :devise_controller?
  #
  # def update_quantity
  #   @order = current_user.orders.cart.first_or_create(number: 0, total: 0)
  #   line_items = @order.line_items
  #   total = line_items.map{ |line_item| line_item.price*line_item.quantity }.sum
  #   @order.update_attributes(number: line_items.sum(:quantity), total: total)
  #   # byebug
  # end
  #
  # protected
  #
  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit :sign_up, keys: [:email, :password, :password_confirmation, :phone, :remember_me, :username, :fit_center, :payment, :gym_id, :item_id]
  #   devise_parameter_sanitizer.permit :sign_in, keys: [:phone, :password]
  #   devise_parameter_sanitizer.permit :account_update, keys: [:email, :password, :password_confirmation, :phone, :remember_me, :username, :gym_id, :item_id]
  # end
  ######################
  rescue_from ActionController::InvalidAuthenticityToken, with: :redirect_to_referer_or_path
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_gym

  def redirect_to_referer_or_path
    redirect_to (request.referer.presence || root_path), notice: '잠시후에 다시 시도 해주세요.'
  end


  def current_gym
    Gym.find(cookies[:gym_id]) rescue current_user&.gym || Gym.first
  end
  

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:email, :password, :passwrd_confirmation, :phone, :remember_me, :gym_id, :referrer, :calorie, :item_id, :gender, :marketing, :privacy, :user_type]
    devise_parameter_sanitizer.permit :sign_in, keys: [:phone, :password]
    devise_parameter_sanitizer.permit :account_update, keys: [:email, :password, :passwrd_confirmation, :phone, :remember_me, :gym_id, :referrer, :calorie, :item_id, :gender, :marketing, :privacy, :user_type]
  end


end
