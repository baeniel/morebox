class ApisController < ApplicationController
  before_action :authenticate_user!, only: %i(pay_url)
  skip_before_action :verify_authenticity_token

  # 부트페이 버전
  def pay_url
    # partner_order_id: "#{gym.id}",
    # partner_user_id: "#{current_user.id}",
    @item = Item.find_by(id: params[:item_id])

    #1. 토큰 발급받기
    bootpay = Bootpay::ServerApi.new(
        "5eb2230002f57e002d1edd8d",
        "GAx0ZCkgGIZuKMlfLgWDbOpAlpSVYV5IWXdmBKURELg="
    )
    result = bootpay.get_access_token

    #2. 결제 링크 생성하기
    if result[:status] == 200
      require 'securerandom'
      random_string = SecureRandom.hex(3)
      order_number = "#{random_string}#{Time.current.to_i}"
      response = bootpay.request_payment(
        pg: 'inicis', # PG Alias
        method: 'card', # Method Alias
        order_id: order_number, # 사용할 OrderId
        price: @item.price, # 결제금액
        items: [{
          item_name: @item.title,
          qty: 1,
          unique: @item.id,
          price: @item.price
          }],
        name: "#{@item.title}", # 상품명
        params: {
          user_id: current_user.id
        },
        # return_url: "http://172.16.101.68:3000/users/#{current_user.id}/pay_complete"
        # return_url: "http://localhost:3000/users/#{current_user.id}/pay_complete"
        return_url: "https://morebox.co.kr/users/#{current_user.id}/pay_complete"
      )
      if (order = current_user.orders.create(status: :ready, gym: current_user.gym, item: @item, order_number: order_number))
        link = response[:data]
        receiver = current_user.phone
        receiverName = current_user.phone.last(4)
        contents = "[MoreBox]\n"+"#{link}"+" 아이폰 유저는 결제 후 뒤로 돌아가주세요"
        payment_alarm = MessageAlarmService.new(receiver, receiverName, contents)
        payment_alarm.send_message

        # link = response[:data]
        # templateCode = '020050000281'
        # content = "[MoveMore]\n"+link+" 님의 사용권이 소진되었습니다ㅠ\n\n아래 버튼으로 결제하시고 헬스장에\n있는 태블릿으로 체크인 하시면 됩니다:)\n\n\n무브모어 카카오톡 채널:\n@무브모어 @movemore"
        # receiver = current_user.phone
        # receiverName = current_user.phone.last(4)
        # kakao_boot = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
        # kakao_boot.send_alarm
      else
        redirect_to items_path, notice: "결제 생성에 실패하였습니다. 다시한번 시도해주세요."
      end
    end
    head :ok
  end

  def pay_complete
    begin
      receipt_id = params[:receipt_id]
      require 'bootpay-rest-client'
      bootpay = Bootpay::ServerApi.new(
          "5eb2230002f57e002d1edd8d",
          "GAx0ZCkgGIZuKMlfLgWDbOpAlpSVYV5IWXdmBKURELg="
      )
      result  = bootpay.get_access_token
      user = nil
      # msg = "결제가 실패하였습니다. 다시 한번 시도해주세요."
      if (result[:status]&.to_s == "200")
        order_number = params[:order_id]
        order = Order.find_by(order_number: order_number)
        verify_response = bootpay.verify(receipt_id)
        user = order.user
        if order && (verify_response[:status]&.to_s == "200") && (verify_response.dig(:data, :status)&.to_s == "1")
          if (item = order.item) && (verify_response[:data][:price] == item&.price)
            if order.ready?
              point = Point.create(amount: item&.point, point_type: :charged, user: user)
              if point
                order.update(status: :complete, paid_at: Time.zone.now, point: point)
              else
                # msg = "포인트 생성에 실패하였습니다. 관리자에게 문의해주세요."
                raise
              end
            else
              # msg = "이미 결제가 된 상품입니다."
              raise
            end

            # 관리자 결제 알람
            templateCode = '020060000152'
            content = user.gym.title + " " + user.phone.last(4) + "님의 " + item&.title + " 결제가 완료되었습니다."
            receiver = '010-5605-3087'
            receiverName = '박진배'
            admin_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
            admin_alarm.send_alarm

            # 결제한 사용자에게 알람
            templateCode = '020050000437'
            content = "[MoveMore]\n정상적으로 결제 되었습니다!\n\n이제 휴대폰 창을 끄시고 헬스장에\n있는 태블릿으로 체크인 하시면 됩니다:)\n\n당신의 땀을 가치있게 만들겠습니다.\n\n\n버튼 클릭하시고 자사몰도 구경하세요!!!"
            receiver = user.phone
            receiverName = user.phone.last(4)
            user_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
            user_alarm.send_alarm
          else
            raise
          end
        else
          raise
        end
      else
        raise
      end
      render html: "OK"
    rescue
      # if user
      #   receiver = user.phone
      #   receiverName = user.phone.last(4)
      #   contents = "[MoreBox]\n"+"#{msg}\n"
      #   payment_alarm = MessageAlarmService.new(receiver, receiverName, contents)
      #   payment_alarm.send_message
      # end
      respond_to do |format|
        format.json { render json: {result: false} }
      end
    end
  end

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
end
