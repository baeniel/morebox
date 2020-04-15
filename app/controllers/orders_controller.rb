class OrdersController < ApplicationController
  before_action :load_object, only: [:update, :destroy, :payment, :show, :request_order]

  def index
  end

  def payment
  end

  def request_order
    @order.update_attribute(order_params)
  end

  def show
  end

  def destroy
  end

  private

  def load_object
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:order_name, :order_phone, :deliver_name, :deliver_phone, :zipcode, :address1, :address2, :requirement, :payment_method, :bank, :bank_owner, :bank_account)
  end
end
