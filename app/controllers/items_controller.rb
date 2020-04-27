class ItemsController < ApplicationController
  def index
    @order = current_user&.orders&.cart&.first_or_create!(number: 0, total: 0)
    # byebug
  end
end
