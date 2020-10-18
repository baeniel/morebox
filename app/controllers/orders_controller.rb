class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:create, :payment]
  before_action :load_object, only: [:update, :show]

  def index
  end

  def create
    food = Food.find params[:order][:food_id]
    order = Order.create(total: food.price)
  end

  def payment
  end

  def update
  end

  def show
  end

  private

  def load_object
    @order = Order.find params[:id]
    @line_item = Order.find params[:id]
  end
end
