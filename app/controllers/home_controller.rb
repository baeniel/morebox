require "browser"

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    browser = Browser.new(request.env["HTTP_USER_AGENT"])
    # 헬스장 태블릿 모어박스
    if browser.device.tablet?
      if current_user.fit_center? == true
        redirect_to gym_path(current_user.gym)
      elsif current_user.manager?
        redirect_to users_path
      else
        redirect_to list_items_path
      end
    else
      if current_user.fit_center? == true
        redirect_to gym_path(current_user.gym)
      elsif current_user.manager?
        redirect_to users_path
      else
        redirect_to root_path, notice: "접근 권한이 없습니다."
      end
    end
  end

  def policy
  end
end
