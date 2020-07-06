require 'popbill/kakaotalk'

class OrdersController < ApplicationController
  before_action :load_object, only: [:update, :show]

  LinkID = "GORILLANUTRI"
  SecretKey = "38GYuKKeb92oktWQhjRm1at/JZIkxScMpkk+y3NfzEE="

  # 팝빌 카카오톡 Service 초기화
  KakaoService = KakaoService.instance(
    OrdersController::LinkID,
    OrdersController::SecretKey
  )

  # 연동환경 설정값, (true-개발용, false-상업용)
  KakaoService.setIsTest(false)

  # 인증토큰 IP제한기능 사용여부, true-권장
  KakaoService.setIpRestrictOnOff(true)

  def index
    # @orders = current_user.orders.paid
  end

  def update
    @item = @order.item

    @order.line_items.where.not(temp: 0).each do |line_item|
      line_item.increment!('quantity', line_item.temp)
      line_item.increment!('point', line_item.temp * SubItem.find_by(title: line_item.title).point)
    end

    @order.update_attributes(number: @order.line_items.sum(:quantity))

    if current_user.orders.sum(:point) - current_user.line_items.sum(:point) <= 2000
      templateCode = '020060000378'
      content = "[MoveMore]\n"+@order.user.phone.last(4)+"님의 "+@order.line_items.where("temp is NOT NULL and temp != 0").map { |item| item.title }.flatten.join(' ')+" "+@order.line_items.sum(:temp).to_s+"개 꺼내기가 완료되었습니다.\n\n현재 잔여 포인트: "+(current_user.orders.sum(:point) - current_user.line_items.sum(:point)).to_s+"포인트\n\n모바일로 모어박스에 로그인하신 후\n헬스장 오시기 전에 결제하세요:)"
    else
      templateCode = '020060000176'
      content = "[MoveMore]\n"+@order.user.phone.last(4)+"님의 "+@order.line_items.where("temp is NOT NULL and temp != 0").map { |item| item.title }.flatten.join(' ')+" "+@order.line_items.sum(:temp).to_s+"개 꺼내기가 완료되었습니다.\n\n현재 잔여 포인트: "+(current_user.orders.sum(:point) - current_user.line_items.sum(:point)).to_s+"포인트\n\n문의사항 있으시면 무브모어 카카오톡 채널로 편하게 연락주시기 바랍니다.\n\n무브모어 카카오톡 채널: @무브모어 @movemore"
    end

    altContent = '대체문자 내용 입니다'
    # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
    altSendType = 'C'
    sndDT = ''
    receiverName = @order.user.phone.last(4)
    receiver = @order.user.phone
    corpNum = "7468701862"
    userID = "jb1014"
    snd = '010-5605-3087'
    requestNum = ''

    begin
      @value = OrdersController::KakaoService.sendATS_one(
          corpNum,
          templateCode,
          snd,
          content,
          altContent,
          altSendType,
          sndDT,
          receiver,
          receiverName,
          requestNum,
          userID,
      )['receiptNum']
      @name = "receiptNum(접수번호)"

    rescue PopbillException => pe
      @Response = pe
      redirect_to home_exception_path
    end

    #데이터베이스 재고 갱신
    @gym = current_user.gym
    gym_stock
    @gym.update_attributes(ultra_stock: @ultra_stock, gorilla_stock: @gorilla_stock, protein_stock: @protein_stock, stock_1: @stock_1, stock_2: @stock_2, stock_3: @stock_3)

    @gyms = Gym.where(gorilla_stock: 15..20).or(Gym.where(ultra_stock: 15..20)).or(Gym.where(protein_stock: 15..20)).or(Gym.where(stock_1: 15..20))
    if @gyms.present?
      templateCode = '020050000216'
      receiverName = '박진배'
      receiver = '010-5605-3087'
      corpNum = "7468701862"
      userID = "jb1014"
      snd = '010-5605-3087'
      altContent = '대체문자 내용 입니다'
      # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
      altSendType = 'C'
      sndDT = ''
      requestNum = ''

      hash = { gorilla: @gym.gorilla_stock, ultra: @gym.ultra_stock, protein: @gym.protein_stock, stock_1: @gym.stock_1, stock_2: @gym.stock_2, stock_3: @gym.stock_3 }
      arr = []
      hash.map.each do |k, v|
        if v > 0 && v < 15
          arr << k
        end
      end

      content = @gym.title+" 센터의 "+arr.map(&:inspect).join(',')+" 재고가 곧 소진됩니다. 센터에 배송해주십시오."

      begin
        @value = OrdersController::KakaoService.sendATS_one(
            corpNum,
            templateCode,
            snd,
            content,
            altContent,
            altSendType,
            sndDT,
            receiver,
            receiverName,
            requestNum,
            userID,
        )['receiptNum']
        @name = "receiptNum(접수번호)"

      rescue PopbillException => pe
        @Response = pe
        redirect_to home_exception_path
      end
    end

  end

  def show
  end

  private

  def load_object
    @order = Order.find params[:id]
    @line_item = Order.find params[:id]
  end

end
  # 모어박스 쇼핑몰 구조
  # before_action :authenticate_user!
  # before_action :load_object, only: [:update, :destroy, :payment, :show, :request_order, :complete]
  #
  # def index
  #   @orders = current_user.orders.paid
  # end
  #
  # def payment
  # end
  #
  # def request_order
  #   @order.update_attributes(order_params)
  # end
  #
  # def show
  # end
  #
  # def destroy
  #   @order.destroy!
  #   redirect_back fallback_location: root_path, notice: "주문이 취소되었습니다."
  # end
  #
  # def complete
  #   @order.paid!
  #   redirect_to root_path, notice: "결제가 완료되었습니다:)"
  # end
  #
  # private
  #
  # def load_object
  #   @order = Order.find(params[:id])
  # end
  #
  # def order_params
  #   params.require(:order).permit(:order_name, :order_phone, :deliver_name, :deliver_phone, :zipcode, :address1, :address2, :requirement, :payment_method, :bank, :bank_owner, :bank_account)
  # end
  #############################3
