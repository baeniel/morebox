class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user&.fit_center? == true
      redirect_to gym_path(current_user&.gym)
    else
      current_user&.line_items.update(temp: 0)
      if current_user&.payment? == true
        redirect_to item_path(current_user&.item)
      else
        redirect_to items_path, notice: "이용권을 구매하셔야 합니다."
      end
    end
  end

  def policy
  end
  
end
