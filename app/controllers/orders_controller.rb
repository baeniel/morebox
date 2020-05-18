class OrdersController < ApplicationController
  before_action :load_object, only: [:update, :show]

  def index
    # @orders = current_user.orders.paid
  end

  def update
    @item = @order.item
    # 장바구니 갯수 최신화
    @order.update_attributes(number: @order.line_items.sum(:quantity))
  end

  def show
  end

  private

  def load_object
    @order = Order.find params[:id]
  end

  # 모어박스 쇼핑몰 구조
  # before_action :authenticate_user!
  # before_action :load_object, only: [:update, :destroy, :payment, :show, :request_order, :complete]
  #
  # def index
  #   @orders = current_user.orders.paid
  # end
  #
  # def payment
  # end
  #
  # def request_order
  #   @order.update_attributes(order_params)
  # end
  #
  # def show
  # end
  #
  # def destroy
  #   @order.destroy!
  #   redirect_back fallback_location: root_path, notice: "주문이 취소되었습니다."
  # end
  #
  # def complete
  #   @order.paid!
  #   redirect_to root_path, notice: "결제가 완료되었습니다:)"
  # end
  #
  # private
  #
  # def load_object
  #   @order = Order.find(params[:id])
  # end
  #
  # def order_params
  #   params.require(:order).permit(:order_name, :order_phone, :deliver_name, :deliver_phone, :zipcode, :address1, :address2, :requirement, :payment_method, :bank, :bank_owner, :bank_account)
  # end
  #############################3
end
