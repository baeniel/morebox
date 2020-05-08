class ItemsController < ApplicationController
  before_action :load_object, only: [:show]

  def index
    @order = current_user&.orders&.cart&.first_or_create!(number: 0, total: 0)
    # byebug
  end

  def show
  end

  private

  def load_object
    @item = Item.find params[:id]
  end
end
