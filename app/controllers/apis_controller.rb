class ApisController < ApplicationController
  def pay_url
    response = HTTParty.post(
      "https://kapi.kakao.com/v1/payment/ready",
      headers: {
        Authorization: "KakaoAK f348a6522071ea17f9dabce9a88b0744"
      },
      body: {
        cid: "CT24824054",#, 발급받은 cid 값
        # cid: "TC0ONETIME", 발급받은 cid 값
        partner_order_id: '0000_'+params[:count], # 가맹점 주문 번호
        partner_user_id: current_user.phone.last(4), # 가맹점 회원 id
        item_name: '고릴라밤',
        quantity: 1,
        total_amount: params[:price],
        vat_amount: 0,
        tax_free_amount: 0,
        # approval_url: "http://localhost:3000/items/#{params[:id]}/",
        approval_url: "http://morebox.co.kr/items/#{params[:id]}/",
        # fail_url: 'http://localhost:3000/',
        fail_url: 'http://morebox.co.kr/',
        # cancel_url: 'http://localhost:3000/',
        cancel_url: 'http://morebox.co.kr/'
      }
    )

    data = response.parsed_response
    cookies[:tid] = data.first.second
    render json: data

  end
end
