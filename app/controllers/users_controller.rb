class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i(index update_referrer updating_referrer)
  skip_before_action :verify_authenticity_token, except: %i[check]

  def index
    redirect_to root_path if current_user.usual?
    @gym = current_user.gym
    # @gym = current_gym
    calculating_trainer_sale
    #트레이너 등수 (기준: 회원가입 많이 시킨 순으로)
    # @managers = User.manager.sort_by{|user| User.where(referrer: user.phone).count }.reverse
  end

  def market
  end

  def pay_complete
    @result = false
    receipt_id = params[:receipt_id]
    require 'bootpay-rest-client'
    bootpay = Bootpay::ServerApi.new(
        "5eb2230002f57e002d1edd8d",
        "GAx0ZCkgGIZuKMlfLgWDbOpAlpSVYV5IWXdmBKURELg="
    )
    result  = bootpay.get_access_token
    if (result[:status]&.to_s == "200")
      verify_response = bootpay.verify(receipt_id) unless Rails.env.development?
      if (Rails.env.development? || (verify_response[:status]&.to_s == "200") && (verify_response.dig(:data, :status)&.to_s == "1"))
        @result = true
      end
    end
    ActionCable.server.broadcast("room_#{params[:id]}", data_type: (@result ? "payment_complete" : "cancel")) if Rails.env.development?
  end

  def update_referrer
    redirect_to list_items_path if current_user.referrer&.present?
  end

  def updating_referrer
    if params[:referrer].present? && params[:referrer]!="010"
      referer = User.manager.find_by(phone: params[:referrer])
      if referer && (referer != current_user)
        current_user.update referrer: params[:referrer]
        #추천인 코드 입력하면 1000원 무료 충전
        Point.create(user: current_user, amount: 1000, point_type: :charged)
        redirect_to list_items_path(gym: current_user.gym.id), notice: "추천인 정보가 입력되었습니다."
      else
        redirect_to update_referrer_user_path(current_user), notice: "추천인 코드가 잘못되었습니다. 확인 후 시도해주세요."
      end
    else
      current_user.update referrer: "-"
      redirect_to list_items_path(gym: current_user.gym.id)
    end
  end

  def check
    @result = (params[:phone_num].present? && (user = User.find_by(phone: params[:phone_num])))
  end

  def check_certificate
    @result = false
    phone_certifications = PhoneCertification.where(phone: params[:phone])
    if params[:_type] == "send"
      phone_certifications.destroy_all
      phone_certification = PhoneCertification.create(phone: params[:phone], code: [*'0'..'9'].sample(6).join)
      receiver = params[:phone]
      receiverName = params[:phone].last(4)
      subject = "MoreBox 인증번호"
      contents = <<-TEXT
[MoreBox]
인증번호 [#{phone_certification}]
입니다.
TEXT
      calorie_alarm = MessageAlarmService.new(receiver, receiverName, subject, contents)
      calorie_alarm.send_message if true || Rails.env.production?
    elsif params[:_type] == "check"
      phone_certification = phone_certifications.first
      if phone_certification.count < 3
        @result = (params[:code] == phone_certification&.code)
        phone_certification.increment!(:count)
      else
        @result = "init"
        phone_certification.destroy
      end
    end
  end
  

  def check_and_send_message
    result = {}
    if params[:phone_num].present? && params[:checked_items].present?
      begin
        link = "http://moremarket.kr"
        receiver = params[:phone_num]
        receiverName = params[:phone_num].last(4)
        subject = receiverName + "님의 식단 가이드"
        contents = <<-TEXT
[MoreBox]
선택하신 상품 목록입니다.
#{params[:checked_items]}

아래 링크에서 트레이너 코드 입력시 할인된 가격에 구매 가능하십니다 :)
구매링크 : #{link}
TEXT
        calorie_alarm = MessageAlarmService.new(receiver, receiverName, subject, contents)
        calorie_alarm.send_message if true || Rails.env.production?
        result[:message] = "문자메세지를<br>전송하였습니다."
      rescue
        result[:message] = "다시 한번<br>시도해주세요."
      end
    else
      result[:message] = "휴대폰 번호를 확인하세요!<br>제품은 선택하셨나요?"
    end

    render json: result
  end
end
