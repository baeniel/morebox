class LineItemsController < ApplicationController
  before_action :load_object, only: [:destroy]

  def index
    @order = current_user.orders.cart.first_or_create
    line_items = @order.line_items
    total = line_items.map{ |line_item| line_item.price*line_item.quantity }.sum
    @order.update_attributes(number: line_items.sum(:quantity), total: total)
  end

  def create
    item = Item.find(params[:line_item][:item_id])
    order = Order.find(params[:line_item][:order_id])
    line_item = order.line_items.where(item: item).first_or_create(quantity: 0, price: item.price)
    line_item.increment!(:quantity)
  end

  def destroy
    @line_item.destroy
  end

  def update
  end

  private

  def load_object
    @line_item = LineItem.find(params[:id])
  end
end
