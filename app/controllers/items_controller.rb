class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_object, only: [:show]

  def index
  end

  def show
  end

  def list
    if params[:gym].present?
      gym = Gym.find(params[:gym])
      #이 두 지점 회원들은 회원가입하면 2500원 무료 충전
      if gym.title == "예스휘트니스" or gym.title == "포이나짐"
        Point.create(amount: 2500, point_type: :charged, user: current_user)
      end
    end
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
