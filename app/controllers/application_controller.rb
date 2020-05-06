class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def update_quantity
    @order = current_user.orders.cart.first_or_create(number: 0, total: 0)
    line_items = @order.line_items
    total = line_items.map{ |line_item| line_item.price*line_item.quantity }.sum
    @order.update_attributes(number: line_items.sum(:quantity), total: total)
    # byebug
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:email, :password, :password_confirmation, :phone, :remember_me, :username]
    devise_parameter_sanitizer.permit :sign_in, keys: [:phone, :password]
    devise_parameter_sanitizer.permit :account_update, keys: [:email, :password, :password_confirmation, :phone, :remember_me, :username]
  end

end
