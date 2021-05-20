require "browser"

class HomeController < ApplicationController
  before_action :authenticate_user!, except: %i(survey survey_start calorie_start fit_table ronie)

  def index
    browser = Browser.new(request.env["HTTP_USER_AGENT"])
    if browser.device.tablet? && check_gym_tablet
      redirect_to list_items_path
    #핸드폰이나 데스크탑 접속할 때
    else
      if current_user.fit_center || current_user.manager?
        if current_user.fit_center
          redirect_to gym_path(current_user.gym)
        else
          redirect_to users_path
        end
      else
        # redirect_to market_users_path
        redirect_to list_items_path
      end
    end
  end

  def policy; end

  def calorie_start; end

  def fit_table
    redirect_to "https://www.sixshop.com/Fittable/home"
  end

  def survey
    # redirect_to root_path, notice: "서비스가 종료되었습니다."
  end

  def survey_start
    # redirect_to root_path, notice: "서비스가 종료되었습니다."
  end
end
