class ApisController < ApplicationController
  before_action :authenticate_user!

  def pay_url
    item = Item.find_by(id: params[:item_id])
    gym = Gym.find_by(id: params[:gym_id])
    if item && gym
      response = HTTParty.post(
        "https://kapi.kakao.com/v1/payment/ready",
        headers: {
          Authorization: "KakaoAK f348a6522071ea17f9dabce9a88b0744"
        },
        body: {
          cid: "CT24824054",
          # cid: "TC0ONETIME",
          partner_order_id: "#{gym.id}", # 가맹점 주문 번호
          partner_user_id: "#{current_user.id}", # 가맹점 회원 id
          item_name: "#{item.title}",
          quantity: 1,
          total_amount: item.price,
          vat_amount: 0,
          tax_free_amount: 0,
          # approval_url: "http://localhost:3000/orders/payment?item_id=#{item.id}",
          approval_url: "https://morebox.co.kr/orders/payment?item_id=#{item.id}",
          # fail_url: 'http://localhost:3000/',
          fail_url: 'https://morebox.co.kr/',
          # cancel_url: 'http://localhost:3000/',
          cancel_url: 'https://morebox.co.kr/'
        }
      )

      data = response.parsed_response
      cookies[:tid] = data.first.second
      render json: data
    else
      render json: {result: false}
    end

  end
end
