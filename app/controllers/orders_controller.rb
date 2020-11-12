class OrdersController < ApplicationController
  before_action :authenticate_user!, except: %i(new create payment complete show send_kakao)
  before_action :load_object, only: %i(update)

  def index
  end

  def new
    unless params[:sub_item_info].present?
      redirect_to survey_path, notice: "선택한 제품이 없습니다."
    else
      sub_item_info = JSON.parse(params[:sub_item_info])
      random_string = SecureRandom.hex(3)
      order_number = "#{random_string}#{Time.current.to_i}"

      @order = Order.new(order_number: order_number)
      sub_item_info.each do |id, qty|
        @order.order_sub_items.build(sub_item_id: id, quantity: qty)
      end
    end
  end

  def create
    @order = Order.find_by order_number: order_params[:order_number]
    @result = false

    if @order
      if @order.ready?
        @order.update order_params
        @result = true
      end
    else
      @order = Order.create order_params
      @result = !@order.new_record?
    end
  end

  def complete
    user = nil
    @order = nil

    begin
      receipt_id = params[:receipt_id]
      require 'bootpay-rest-client'
      bootpay = Bootpay::ServerApi.new(
          "5eb2230002f57e002d1edd8d",
          "GAx0ZCkgGIZuKMlfLgWDbOpAlpSVYV5IWXdmBKURELg="
      )
      result  = bootpay.get_access_token
      msg = "결제가 실패하였습니다. 다시 한번 시도해주세요."
      @result = false

      if (result[:status]&.to_s == "200")
        order_number = params[:order_id]
        @order = Order.find_by(order_number: order_number)
        verify_response = bootpay.verify(receipt_id) unless Rails.env.development?
        user = @order.user

        if @order && (Rails.env.development? || (verify_response[:status]&.to_s == "200") && (verify_response.dig(:data, :status)&.to_s == "1"))
          total_price = 0
          if @order.item
            total_price = @order.item&.price
          else
            total_price = @order.order_sub_items&.inject(0){|sum, order_sub_item| sum + (order_sub_item.quantity * order_sub_item&.sub_item&.point)}
          end
          if (Rails.env.development? || ((item = @order.item) || @order.sub_items&.exists?) && (verify_response[:data][:price] == total_price))
            # if @order.ready?
              point = nil
              @data_type =  @order.item ? "payment_complete" : "direct_complete"
              @result = true
              amount = 0
              # if @order.item
              #   amount = @order.trainer ? (@order.item&.point + (total_price.to_f * 0.05)) : @order.item&.point
              # else
              #   @data_type = "direct_complete"
              #   amount = @order.order_sub_items&.inject(0){|sum, order_sub_item| sum + (order_sub_item.quantity * order_sub_item&.sub_item&.point)}
              # end
              # ActionCable.server.broadcast("room_#{user.id}", data_type: data_type)
              # if (point = Point.create(amount: amount, point_type: :charged, user: user, gym: current_gym))
              #   @order.update(status: :complete, paid_at: Time.zone.now, point: point, payment_amount: total_price)
              #   if @order.sub_items&.exists?
              #     @order.sub_items.each do |sub_item|
              #       point = Point.create(user: user, point_type: :used, amount: sub_item.point, sub_item: sub_item, remain_point: (user.remained_point-sub_item.point), gym: current_gym)
              #     end
              #   end
              #   # ActionCable.server.broadcast("room_#{user.id}", data_type: data_type)
              # else
              #   # msg = "포인트 생성에 실패하였습니다. 관리자에게 문의해주세요."
              #   raise
              # end
            # else
              # msg = "이미 결제가 된 상품입니다."
              # raise
            # end
            # title = item&.title || "#{@order.sub_items.first&.title} 포함 #{@order.sub_items.count}개 상품"

            # # 관리자 결제 알람
            # templateCode = '020100000007'
            # content = user.gym.title + " " + user.phone.last(4) + "님의 " + title + " 결제가 완료되었습니다."
            # receiver = '010-5605-3087'
            # receiverName = '박진배'
            # admin_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
            # admin_alarm.send_alarm if Rails.env.production?

            # # 결제한 사용자에게 알람
            # templateCode = '020100000008'
            # content = "[MoreMarket]\n정상적으로 결제 되었습니다!\n\n이제 휴대폰 창을 끄시고 헬스장에\n있는 태블릿으로 체크인 하시면 됩니다:)\n\n당신의 땀을 가치있게 만들겠습니다.\n\n\n버튼 클릭하시고 자사몰도 구경하세요!!!"
            # receiver = user.phone
            # receiverName = user.phone.last(4)
            # user_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
            # user_alarm.send_alarm

          else
            raise
          end
        else
          raise
        end
      else
        raise
      end
      @result = true
    rescue
      if @order && @order.user && @order.ready?
        @order.incomplete!
        receiver = user.phone
        receiverName = user.phone.last(4)
        contents = "[MoreBox]\n"+"#{msg}\n"
        payment_alarm = MessageAlarmService.new(receiver, receiverName, contents)
        payment_alarm.send_mms
      end
    end

  end

  def payment;end

  def update;end

  def show
    @order = Order.where(order_phone: params[:phone], order_number: params[:order_number]).first
    redirect_to survey_path, notice: "일치하는 정보가 없습니다. 다시 한번 확인해 주세요." unless @order.present?
  end

  def send_kakao
    link = "http://pf.kakao.com/_WlPxlK/chat"
    receiver = params[:order_phone]
    receiverName = "귀하"
    subject = "문의하기"
    contents = "[MoreMarket]\n"+"#{link}\n"+" 위 링크에서 카카오톡으로 문의해주세요:)"
    question_alarm = MessageAlarmService.new(receiver, receiverName, subject, contents)
    question_alarm.send_message
  end

  private

  def load_object
    @order = Order.find params[:id]
    @line_item = Order.find params[:id]
  end

  def order_params
    params.require(:order).permit(:order_number, :order_name, :order_phone, :deliver_name, :order_type, :deliver_phone, :zipcode, :address1, :address2, :total, order_sub_items_attributes: [:sub_item_id, :quantity])
  end
end
