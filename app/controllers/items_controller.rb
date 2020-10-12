class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_own_tablet
  before_action :load_object, only: [:show]

  def index
  end

  def show
  end

  def list ;end

  def send_survey
    link = "https://morebox.co.kr/survey"
    receiver = current_user.phone
    receiverName = current_user.phone.last(4)
    subject = "칼로리 계산기"
    contents = "[MoreMarket]\n"+"#{link}\n"+" 대체 뭘 먹어야 할 지 모르시겠죠?\n 질문 몇 개만 답하시고 식단 받아보세요:)"
    calorie_alarm = MessageAlarmService.new(receiver, receiverName, subject, contents)
    calorie_alarm.send_message
  end

  def auto_out
    sign_out current_user
    redirect_to root_path, notice: "다음에 다시 이용해주시기 바랍니다:)"
  end

  private

  def load_object
    @item = Item.find params[:id]
  end
  def check_own_tablet
    redirect_to root_path unless check_gym_tablet
  end
end
