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

    @order.line_items.each do |line_item|
      if line_item.temp != 0
        line_item.update_attributes(quantity: line_item.temp)
      end
    end

    # @line_item.update_attributes(quantity: @line_item.sum(:temp))
    @order.update_attributes(number: @order.line_items.sum(:quantity))

    #사용권이 만료됐을 때
    # if @item.count == @order.number
    #   templateCode = '020050000281'
    #   content = "[MoveMore]\n"+@order.user.phone.last(4)+"님의 사용권이 소진되었습니다ㅠ\n\n아래 버튼으로 결제하시고 헬스장에\n있는 태블릿으로 체크인 하시면 됩니다:)\n\n\n무브모어 카카오톡 채널:\n@무브모어 @movemore"
    # else
    #사용권 남아있을 때
    templateCode = '020040000334'
    content = "[MoveMore]\n"+@order.user.phone.last(4)+"님의 "+@order.line_items.where("temp is NOT NULL and temp != 0").map { |item| item.title }.flatten.join(' ')+@order.line_items.sum(:temp).to_s+"개 꺼내기가 완료되었습니다.\n\n현재 잔여 갯수: "+(@item.count-@order.number).to_s+"개\n\n문의사항 있으시면 무브모어 카카오톡 채널로 편하게 연락주시기 바랍니다.\n\n무브모어 카카오톡 채널: @무브모어 @movemore"
    # end

    altContent = '대체문자 내용 입니다'
    # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
    altSendType = 'A'
    # 예약일시 (작성형식: 20190120012753 yyyyMMddHHmmss)
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

    #재고가 부족한 헬스장 찾기
    @gyms = Gym.where(gorilla_stock: 15..20).or(Gym.where(ultra_stock: 15..20)).or(Gym.where(protein_stock: 15..20))

    if @gyms.present?
      templateCode = '020050000216'
      content = @gyms.pluck(:title).map { |gym| gym }.join()+" 센터의 재고가 곧 소진됩니다. 센터에 배송해주십시오."
      receiverName = '박진배'
      receiver = '010-5605-3087'
      corpNum = "7468701862"
      userID = "jb1014"
      snd = '010-5605-3087'
      altContent = '대체문자 내용 입니다'
      # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
      altSendType = 'A'
      # 예약일시 (작성형식: 20190120012753 yyyyMMddHHmmss)
      sndDT = ''
      # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
      # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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
    end
  end

  def show
  end

  private

  def load_object
    @order = Order.find params[:id]
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
