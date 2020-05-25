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
      current_user.update_attributes(payment: true)
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
