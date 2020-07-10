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
  ######################3

  before_action :configure_permitted_parameters, if: :devise_controller?

  def gym_stock
    @ultra_stock = @gym.ultra_purchase - @gym.line_items.where(title: "몬스터울트라").sum(:quantity)
    @gorilla_stock = @gym.gorilla_purchase - @gym.line_items.where(title: "고릴라밤").sum(:quantity)

    if (@gym.title == "테라피티(언주)" || @gym.title == "에이짐휘트니스")
      @protein_stock = @gym.protein_purchase - @gym.line_items.where(title: "칼로바이프로틴바").sum(:quantity)
    else
      @protein_stock = @gym.protein_purchase - @gym.line_items.where(title: "커클랜드프로틴바").sum(:quantity)
    end

    @stock_1 = @gym.purchase_1 - @gym.line_items.where(title: "프로틴에이드").sum(:quantity)

    if @gym.title == "스프링타운2층"
      @stock_1 = @gym.purchase_1 - @gym.line_items.where(title: "과일").sum(:quantity)
    end

    if @gym.title == "에이짐휘트니스"
      @stock_2 = @gym.purchase_2 - @gym.line_items.where(title: "닭가슴살볶음밥").sum(:quantity)
    else
      @stock_2 = @gym.purchase_2 - @gym.line_items.where(title: "닭가슴살칩").sum(:quantity)
    end

    if @gym.title == "에이짐휘트니스"
      @stock_3 = @gym.purchase_3 - @gym.line_items.where(title: "닭가슴살").sum(:quantity)
    else
      @stock_3 = @gym.purchase_3 - @gym.line_items.where(title: "닭가슴살육포").sum(:quantity)
    end

    if @gym.title == "에이짐휘트니스"
      @stock_4 = @gym.purchase_4 - @gym.line_items.where(title: "파워에이드").sum(:quantity)
    else
      @stock_4 = @gym.purchase_4 - @gym.line_items.where(title: "파워쉐이크").sum(:quantity)
    end

  end

  def update_drink_quantity
    # @item = Item.find params[:id]

    @order = Order.where(user: current_user, item: @item).last
    if (@order.nil? || (@order&.number > 0 && (current_user.orders.sum(:point) - current_user.line_items.sum(:point) < current_user.gym.sub_items.order('point asc').first.point)))
      @order = current_user.orders.create(item: @item, number: 0, gym: current_user.gym, point: @item.point)
    end

    titles = current_user.gym&.sub_items&.pluck(:title)
    titles.each do |title|
      LineItem.where(title: title, order: @order).first_or_create(quantity: 0, temp: 0)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:email, :password, :passwrd_confirmation, :phone, :remember_me, :gym_id, :calorie, :item_id, :gender]
    devise_parameter_sanitizer.permit :sign_in, keys: [:phone, :password]
    devise_parameter_sanitizer.permit :account_update, keys: [:email, :password, :passwrd_confirmation, :phone, :remember_me, :gym_id, :calorie, :item_id, :gender]
  end


end
