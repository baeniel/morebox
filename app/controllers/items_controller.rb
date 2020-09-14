class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_object, only: [:show]

  def index
  end

  def show
  end

  def list ;end

  def auto_out
    sign_out current_user
    redirect_to root_path, notice: "다음에 다시 이용해주시기 바랍니다:)"
  end

  private

  def load_object
    @item = Item.find params[:id]
  end
end
