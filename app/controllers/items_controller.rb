require 'popbill/kakaotalk'

class ItemsController < ApplicationController
  before_action :load_object, only: [:show]
  # skip_before_action :verify_authenticity_token

  #모어박스 쇼핑몰 형태
  # def index
  #   @order = current_user&.orders&.cart&.first_or_create!(number: 0, total: 0)
  # end
  #
  # def show
  # end
  #
  # private
  #
  # def load_object
  #   @item = Item.find params[:id]
  # end
  ########################

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
  end

  def show
    current_user&.item = @item

    #맨 처음 가입할 때 빈 창 뜨는 것을 방지하기 위해서
    if current_user.orders.count == 0
      update_drink_quantity
    else
      @order = Order.where(user: current_user, item: @item).last
    end

    titles = current_user.gym&.sub_items&.pluck(:title)
    titles.each do |title|
      LineItem.where(title: title, order: @order).first_or_create(quantity: 0, temp: 0)
    end

    @gym = current_user.gym

    if params[:pg_token].present?
      response = HTTParty.post(
        "https://kapi.kakao.com/v1/payment/approve",
        headers: {
          Authorization: "KakaoAK f348a6522071ea17f9dabce9a88b0744"
        },
        body: {
          cid: "CT24824054", # 발급받은 cid 값
          tid: cookies[:tid],
          partner_order_id: '12345678', # 가맹점 주문 번호
          partner_user_id: '123', # 가맹점 회원 id
          pg_token: params[:pg_token]
        }
      )
      case response.code
      when 200
        #결제가 성공적으로 이루어졌을 때
        # @order = Order.where(user: current_user, item: @item).last
        # @order = current_user.orders.create(item: @item, number: 0, gym: current_user.gym, point: @item.point)

        titles = @gym&.sub_items&.pluck(:title)
        titles.each do |title|
          LineItem.where(title: title, order: @order).first_or_create(quantity: 0, temp: 0)
        end

        current_user.update_attributes(payment: true)

        templateCode = '020050000437'
        content = "[MoveMore]\n정상적으로 결제 되었습니다!\n\n이제 휴대폰 창을 끄시고 헬스장에\n있는 태블릿으로 체크인 하시면 됩니다:)\n\n당신의 땀을 가치있게 만들겠습니다.\n\n\n버튼 클릭하시고 자사몰도 구경하세요!!!"
        corpNum = "7468701862"
        userID = "jb1014"
        snd = '010-5605-3087'
        altContent = '대체문자 내용 입니다'
        # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
        altSendType = 'C'
        sndDT = ''
        receiverName = @order.user.phone.last(4)
        receiver = @order.user.phone
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

        #관리자 결제 알람
        templateCode = '020060000152'
        content = current_user.gym.title+" "+current_user.phone.last(4)+"님의 "+@order.item.title+" 결제가 완료되었습니다."
        corpNum = "7468701862"
        userID = "jb1014"
        snd = '010-5605-3087'
        altContent = '대체문자 내용 입니다'
        # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
        altSendType = 'C'
        sndDT = ''
        receiverName = '박진배'
        receiver = '010-5605-3087'
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

      else
        # redirect_back fallback_location: root_path, notice: "#{response.message}"
        # {'error' => response.message}
      end
    else
      if @order.nil?
        @order = current_user.orders.create(item: @item, number: 0, gym: current_user.gym, point: @item.point)
      end
    end

  end

  def auto_out
    sign_out current_user
    redirect_to root_path, notice: "다음에 다시 이용해주시기 바랍니다:)"
  end

  private

  def load_object
    @item = Item.find params[:id]
  end
end
