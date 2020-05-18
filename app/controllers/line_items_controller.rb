class LineItemsController < ApplicationController
  before_action :load_object

  # 음료수 갯수 조정
  def update
    @line_item.increment!(:temp)
    @line_item.increment!(:quantity)
  end

  def reduce
    @line_item.decrement!(:temp)
    @line_item.decrement!(:quantity)
  end

  def load_object
    @line_item = LineItem.find params[:id]
    @order = @line_item.order
  end

  
  #모어박스 쇼핑몰 구조
  # before_action :authenticate_user!, only: [:index]
  # before_action :load_object, only: [:destroy, :reduce, :update]
  #
  # def index
  #   update_quantity
  # end
  #
  # def create
  #   item = Item.find(params[:line_item][:item_id])
  #   order = Order.find(params[:line_item][:order_id])
  #   line_item = order.line_items.where(item: item).first_or_create(quantity: 0, price: item.price)
  #   line_item.increment!(:quantity)
  # end
  #
  # def destroy
  #   @line_item.destroy
  # end
  #
  # def reduce
  #   @line_item.decrement!(:quantity)
  #   update_quantity
  # end
  #
  # def update
  #   @line_item.increment!(:quantity)
  #   update_quantity
  # end
  #
  # private
  #
  # def load_object
  #   @line_item = LineItem.find(params[:id])
  # end
  ######################################
end
