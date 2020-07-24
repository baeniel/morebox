class ApisController < ApplicationController
  before_action :authenticate_user!
  # skip_before_action :verify_authenticity_token

  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?

  # def pay_url
  #   # 카카오페이 버전
  #   item = Item.find_by(id: params[:item_id])
  #   gym = Gym.find_by(id: params[:gym_id])
  #   if item && gym
  #     response = HTTParty.post(
  #       "https://kapi.kakao.com/v1/payment/ready",
  #       headers: {
  #         Authorization: "KakaoAK f348a6522071ea17f9dabce9a88b0744"
  #       },
  #       body: {
  #         cid: "CT24824054",
  #         # cid: "TC0ONETIME",
  #         partner_order_id: "#{gym.id}", # 가맹점 주문 번호
  #         partner_user_id: "#{current_user.id}", # 가맹점 회원 id
  #         item_name: "#{item.title}",
  #         quantity: 1,
  #         total_amount: item.price,
  #         vat_amount: 0,
  #         tax_free_amount: 0,
  #         # approval_url: "http://localhost:3000/orders/payment?item_id=#{item.id}",
  #         approval_url: "https://morebox.co.kr/orders/payment?item_id=#{item.id}",
  #         # fail_url: 'http://localhost:3000/',
  #         fail_url: 'https://morebox.co.kr/',
  #         # cancel_url: 'http://localhost:3000/',
  #         cancel_url: 'https://morebox.co.kr/'
  #       }
  #     )
  #
  #     data = response.parsed_response
  #     cookies[:tid] = data.first.second
  #     render json: data
  #   else
  #     render json: {result: false}
  #   end
  # end

  # 부트페이 버전
  def pay_url
    item = Item.find_by(id: params[:item_id])
    session[:passed_id] = item.id
    session[:passed_price] = item.price

    # partner_order_id: "#{gym.id}",
    # partner_user_id: "#{current_user.id}",

    bootpay = Bootpay::ServerApi.new(
      "5eb2230002f57e002d1edd8d",
      "GAx0ZCkgGIZuKMlfLgWDbOpAlpSVYV5IWXdmBKURELg="
    )

    result  = bootpay.get_access_token

    if result[:status] == 200
      response = bootpay.request_payment(
        pg: 'inicis', # PG Alias
        method: 'card', # Method Alias
        order_id: (Time.current.to_i), # 사용할 OrderId
        price: item.price, # 결제금액
        name: "#{item.title}", # 상품명
        # return_url: 'http://localhost:3000/apis/pay_complete'
        return_url: 'https://morebox.co.kr/apis/pay_complete'
      )

      link = response[:data]
      receiver = current_user.phone
      receiverName = current_user.phone.last(4)
      contents = "[MoreBox]\n"+"아래 링크로 접속하셔서 결제하세요!\n"+"#{link}"
      payment_alarm = MessageAlarmService.new(receiver, receiverName, contents)
      payment_alarm.send_message

      # link = response[:data]
      # templateCode = '020050000281'
      # content = "[MoveMore]\n"+link+" 님의 사용권이 소진되었습니다ㅠ\n\n아래 버튼으로 결제하시고 헬스장에\n있는 태블릿으로 체크인 하시면 됩니다:)\n\n\n무브모어 카카오톡 채널:\n@무브모어 @movemore"
      # receiver = current_user.phone
      # receiverName = current_user.phone.last(4)
      # kakao_boot = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
      # kakao_boot.send_alarm
    end
  end

  def pay_complete

    item = Item.find_by(id: session[:passed_id])
    price = session[:passed_price]

    begin
      receipt_id = params[:receipt_id]
      require 'bootpay-rest-client'
      bootpay = Bootpay::ServerApi.new(
          "5eb2230002f57e002d1edd8d",
          "GAx0ZCkgGIZuKMlfLgWDbOpAlpSVYV5IWXdmBKURELg="
      )
      result  = bootpay.get_access_token
      if result[:status] == 200
        verify_response = bootpay.verify(receipt_id)
        if verify_response[:status] == 200
          if verify_response[:data][:status] == 1 or verify_response[:data][:price] == price
            Point.transaction do
              point = Point.create(amount: item.point, point_type: :charged, user: current_user)
              @order = current_user.orders.create(status: :complete, paid_at: Time.zone.now, gym: current_user.gym, item: item, point: point)
            end

            # 관리자 결제 알람
            templateCode = '020060000152'
            content = current_user.gym.title+" "+current_user.phone.last(4)+"님의 "+item.title+" 결제가 완료되었습니다."
            receiver = '010-5605-3087'
            receiverName = '박진배'
            admin_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
            admin_alarm.send_alarm

            # 결제한 사용자에게 알람
            templateCode = '020050000437'
            content = "[MoveMore]\n정상적으로 결제 되었습니다!\n\n이제 휴대폰 창을 끄시고 헬스장에\n있는 태블릿으로 체크인 하시면 됩니다:)\n\n당신의 땀을 가치있게 만들겠습니다.\n\n\n버튼 클릭하시고 자사몰도 구경하세요!!!"
            receiver = @order.user.phone
            receiverName = @order.user.phone.last(4)
            user_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
            user_alarm.send_alarm

            sign_out current_user
            # redirect_to list_items_path(alert: true)
          else
            raise
          end
        else
          raise
        end
      else
        raise
      end
    rescue
      redirect_to root_path, notice: "찾으시는 상품이 없습니다. 관리자에게 문의해주세요."
    end
  end

  protected

  def json_request?
    request.format.json?
  end
end
