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
    @protein_stock = @gym.protein_purchase - @gym.line_items.where(title: "프로틴바").sum(:quantity)
    @stock_1 = @gym.purchase_1 - @gym.line_items.where(title: "과일").sum(:quantity)

    # @stock2 = @gym.purchase_2 - @gym.line_items.where(title: "닥터유프로틴바").sum(:quantity)


    # @stock3 = @gym.purchase_3 - @gym.line_items.where(title: "닭가슴살").sum(:quantity)
    # @stock4 = @gym.purchase_4 - @gym.line_items.where(title: "요거트").sum(:quantity)
  end

  def update_drink_quantity
    @item = Item.find params[:id]

    @order = Order.where(user: current_user, item: @item).last
    if (@order.nil? || (@order&.number > 0 && (@order&.number % @item.count == 0)))
      @order = current_user.orders.create(item: @item, number: 0, gym: current_user.gym)
    end

    # if @item.count == 1
    #   @order = current_user.orders.first_or_create(item: @item, number: 0, gym: current_user.gym)
    # else
    #   @order = Order.where(user: current_user, item: @item).last
    #   if (@order.nil? || (@order&.number > 0 && (@order&.number % @item.count == 0)))
    #     @order = current_user.orders.create(item: @item, number: 0, gym: current_user.gym)
    #   end
    # end

    #line_item 3가지 생성
    # titles = ["몬스터울트라", "고릴라밤", "프로틴바"]
    # titles.each do |title|
    #   LineItem.where(title: title, order: @order).first_or_create(quantity: 0, temp: 0)
    # end

    titles = current_user.gym&.sub_items&.pluck(:title)
    titles.each do |title|
      LineItem.where(title: title, order: @order).first_or_create(quantity: 0, temp: 0)
      # LineItem.where(title: title, order: @order).first_or_create(quantity: 0, temp: 0)
    end

    # sub_item을 어드민에 등록시키고, 이 때 gym_id도 같이 등록
    # sub_item과 gym을 line_item을 연결 고리로 해서 m:n 관계
    # line_item은 sub_item의 id가 있어야 하기에, LineItem만들 때 sub_item id를 넣어준다.

    # card에서 line_item들이 나오고 있는데, 이것을 @gym.sub_items로 변경
    #

  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:email, :password, :passwrd_confirmation, :phone, :remember_me, :gym_id, :calorie, :item_id]
    devise_parameter_sanitizer.permit :sign_in, keys: [:phone, :password]
    devise_parameter_sanitizer.permit :account_update, keys: [:email, :password, :passwrd_confirmation, :phone, :remember_me, :gym_id, :calorie, :item_id]
  end


end
