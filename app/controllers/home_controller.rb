class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.fit_center? == true
      redirect_to gym_path(current_user.gym)
    else
      # current_user&.line_items&.update(temp: 0)
      redirect_to items_path
    end
  end

  def policy
  end
end
