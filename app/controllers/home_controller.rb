require "browser"

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    browser = Browser.new(request.env["HTTP_USER_AGENT"])
    #태블릿일 때 (추후 시크릿 코드 분기 필요)
    if browser.device.tablet?
      redirect_to list_items_path
    #핸드폰이나 데스크탑 접속할 때
    else
      if current_user.fit_center || current_user.manager?
        if current_user.fit_center
          redirect_to gym_path(current_user.gym)
        elsif current_user.manager?
          redirect_to users_path
        else
          redirect_to gym_path(current_user.gym)
        end
      else
        redirect_to root_path, notice: "접근 권한이 없습니다."
      end
    end
  end

  def policy
  end
end
