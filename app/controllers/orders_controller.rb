class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_object, only: [:update, :show]

  def index
    # @orders = current_user.orders.paid
  end

  # 카카오페이코드
  def payment
    # begin
    #   if (item = Item.find_by(id: params[:item_id]))
    #     if params[:pg_token].present?
    #       gym = current_user.gym
    #       response = HTTParty.post(
    #        "https://kapi.kakao.com/v1/payment/approve",
    #        headers: {
    #          Authorization: "KakaoAK f348a6522071ea17f9dabce9a88b0744"
    #        },
    #        body: {
    #          cid: "CT24824054",
    #          # cid: "TC0ONETIME",
    #          tid: cookies[:tid],
    #          partner_order_id: "#{gym.id}", # 가맹점 주문 번호
    #          partner_user_id: "#{current_user.id}", # 가맹점 회원 id
    #          pg_token: params[:pg_token],
    #          total_amount: item.price
    #        }
    #      )
    #      case response.code
    #      when 200
    #        #결제가 성공적으로 이루어졌을 때
    #        Point.transaction do
    #          point = Point.create(amount: item.point, point_type: :charged, user: current_user)
    #          @order = current_user.orders.create(status: :complete, paid_at: Time.zone.now, gym: current_user.gym, item: item, payment_amount: response.dig(:amount, :total), tid: cookies[:tid], point: point)
    #        end
    #
    #        # 결제한 사용자에게 알람
    #        templateCode = '020050000437'
    #        content = "[MoveMore]\n정상적으로 결제 되었습니다!\n\n이제 휴대폰 창을 끄시고 헬스장에\n있는 태블릿으로 체크인 하시면 됩니다:)\n\n당신의 땀을 가치있게 만들겠습니다.\n\n\n버튼 클릭하시고 자사몰도 구경하세요!!!"
    #        receiver = @order.user.phone
    #        receiverName = @order.user.phone.last(4)
    #        user_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
    #        user_alarm.send_alarm
    #
    #        # 관리자 결제 알람
    #        templateCode = '020060000152'
    #        content = current_user.gym.title+" "+current_user.phone.last(4)+"님의 "+item.title+" 결제가 완료되었습니다."
    #        receiver = '010-5605-3087'
    #        receiverName = '박진배'
    #        admin_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
    #        admin_alarm.send_alarm
    #
    #        redirect_to list_items_path(alert: true)
    #      else
    #        raise
    #      end
    #    else
    #      raise
    #    end
    #  else
    #    raise
    #  end
    # rescue
    #   redirect_to root_path, notice: "찾으시는 상품이 없습니다. 관리자에게 문의해주세요."
    # end
  end

  def update
    #데이터베이스 재고 갱신
    # @gym = current_user.gym
    # gym_stock
    # @gym.update_attributes(ultra_stock: @ultra_stock, gorilla_stock: @gorilla_stock, protein_stock: @protein_stock, stock_1: @stock_1, stock_2: @stock_2, stock_3: @stock_3, stock_4: @stock_4)
    #
    # @gyms = Gym.where(gorilla_stock: 15..20).or(Gym.where(ultra_stock: 15..20)).or(Gym.where(protein_stock: 15..20)).or(Gym.where(stock_1: 15..20))
    # if @gyms.present?
    #   templateCode = '020050000216'
    #   receiverName = '박진배'
    #   receiver = '010-5605-3087'
    #   corpNum = "7468701862"
    #   userID = "jb1014"
    #   snd = '010-5605-3087'
    #   altContent = '대체문자 내용 입니다'
    #   # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
    #   altSendType = 'C'
    #   sndDT = ''
    #   requestNum = ''
    #
    #   hash = { gorilla: @gym.gorilla_stock, ultra: @gym.ultra_stock, protein: @gym.protein_stock, stock_1: @gym.stock_1, stock_2: @gym.stock_2, stock_3: @gym.stock_3 }
    #   arr = []
    #   hash.map.each do |k, v|
    #     if v > 0 && v < 15
    #       arr << k
    #     end
    #   end
    #
    #   content = @gym.title+" 센터의 "+arr.map(&:inspect).join(',')+" 재고가 곧 소진됩니다. 센터에 배송해주십시오."
    #
    #   begin
    #     @value = OrdersController::KakaoService.sendATS_one(
    #         corpNum,
    #         templateCode,
    #         snd,
    #         content,
    #         altContent,
    #         altSendType,
    #         sndDT,
    #         receiver,
    #         receiverName,
    #         requestNum,
    #         userID,
    #     )['receiptNum']
    #     @name = "receiptNum(접수번호)"
    #
    #   rescue PopbillException => pe
    #     @Response = pe
    #     redirect_to home_exception_path
    #   end
    # end
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
