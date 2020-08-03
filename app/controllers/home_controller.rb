class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.fit_center? == true
      redirect_to gym_path(current_user&.gym)
    elsif (current_user.phone == "01077777777")
      redirect_to gyms_path
    else
      redirect_to list_items_path
    end
  end

  def policy
  end

end
