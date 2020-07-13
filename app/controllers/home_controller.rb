class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.fit_center? == true
      redirect_to gym_path(current_user&.gym)
    else
      if (current_user.remained_point > 0)
        redirect_to list_items_path
      else
        redirect_to items_path, notice: "이용권을 구매하셔야 합니다."
      end
    end
  end

  def policy
  end

end
