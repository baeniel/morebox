require 'popbill/kakaotalk'

class ItemsController < ApplicationController
  before_action :load_object, only: [:show]

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
    update_drink_quantity

    #데이터베이스 재고 갱신
    @gym = @order.gym
    gym_stock
    @gym.update_attributes(ultra_stock: @ultra_stock, gorilla_stock: @gorilla_stock, protein_stock: @protein_stock)

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
      case response
        when Net::HTTPSuccess
          current_user.update_attributes(payment: true)
          templateCode = '020050000309'
          content = "[MoveMore]\n정상적으로 결제 되었습니다!\n\n당신의 땀을 가치있게 만들겠습니다.\nMake Your Sweat Worth, MoveMore\n\n버튼 클릭하시고 자사몰도 구경하세요!!!"
          corpNum = "7468701862"
          userID = "jb1014"
          snd = '010-5605-3087'
          altContent = '대체문자 내용 입니다'
          # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
          altSendType = 'A'
          # 예약일시 (작성형식: 20190120012753 yyyyMMddHHmmss)
          sndDT = ''
          receiverName = @order.user.phone.last(4)
          receiver = @order.user.phone
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
        else
          # redirect_back fallback_location: root_path, notice: "#{response.message}"
          # {'error' => response.message}
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
