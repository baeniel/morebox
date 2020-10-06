class ApplicationController < ActionController::Base
  rescue_from ActionController::InvalidAuthenticityToken, with: :redirect_to_referer_or_path
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_params
  helper_method :current_gym
  helper_method :check_gym_tablet

  def redirect_to_referer_or_path
    redirect_to (request.referer.presence || root_path), notice: '잠시후에 다시 시도 해주세요.'
  end

  def check_params
    cookies[:secret] = params[:secret] if params[:secret].present?
  end
  
  def check_gym_tablet
    (cookies[:secret] == "gorilla")
  end
  

  def calculating_trainer_sale
    @arr = []
    @arr2 = []
    this_month = Date.today.month

    # 이거 새롭게 변경되어야 할 것 같음 / 그리고 application controller말고 그냥 액션으로 빼는쪽으로
    # this_month_completed_orders = current_user.assisted_orders.complete.where(paid_at: Date.today.beginning_of_month..Date.today)
    # @month_trainer_sale = this_month_completed_orders.sum(:payment_amount)
    # @trainer_commission = (@month_trainer_sale * 0.1).to_i
    User.where(referrer: current_user.phone).each do |user|
      complete_orders = user.orders.complete.includes(:item)
      @arr << complete_orders.map{|order| order.created_at.month.eql?(this_month) ? order.item&.price : 0 }&.sum
      @arr2 << complete_orders.map{|order| order.item&.price }&.sum
    end
    @month_trainer_sale = @arr.sum.to_i
    @trainer_commission = (@month_trainer_sale * 0.1).to_i
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
