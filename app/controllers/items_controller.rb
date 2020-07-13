class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_object, only: [:show]
  # skip_before_action :verify_authenticity_token

  #모어박스 쇼핑몰 형태
  # def index
  #   @order = current_user&.orders&.cart&.first_or_create!(number: 0, total: 0)
  # end
  #
  # def show
  # end
  #
  # private
  #
  # def load_object
  #   @item = Item.find params[:id]
  # end
  ########################


  def index
  end

  def show
  end

  def list
  end

  def auto_out
    sign_out current_user
    redirect_to root_path, notice: "다음에 다시 이용해주시기 바랍니다:)"
  end

  private

  def load_object
    @item = Item.find params[:id]
  end
end
