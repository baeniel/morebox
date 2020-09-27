require "browser"

class HomeController < ApplicationController
  before_action :authenticate_user!, except: %i(survey)

  def index
    browser = Browser.new(request.env["HTTP_USER_AGENT"])
    #태블릿일 때 (추후 시크릿 코드 분기 필요)
    if browser.device.tablet? # && params[:secret_code] == "gorillabom"
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
        redirect_to market_users_path
      end
    end
  end

  def policy
  end

  def survey; end
  
end
