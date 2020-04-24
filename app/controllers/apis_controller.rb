class ApisController < ApplicationController
  def pay_url
    response = HTTParty.post(
      "https://kapi.kakao.com/v1/payment/ready",
      headers: {
        Authorization: "KakaoAK f348a6522071ea17f9dabce9a88b0744"
      },
      body: {
        cid: "TC0ONETIME", # 발급받은 cid 값
        partner_order_id: 'partner_order_id', # 가맹점 주문 번호
        partner_user_id: 'partner_user_id', # 가맹점 회원 id
        item_name: '고릴라밤',
        total_amount: params[:total],
        quantity: params[:number],
        vat_amount: 0,
        tax_free_amount: 0,
        approval_url: "http://localhost:3000/orders/#{params[:id]}/complete",
        # approval_url: "http://connect-gorilla.com/items/#{params[:id]}",
        fail_url: 'http://localhost:3000/',
        # fail_url: 'http://connect-gorilla.com/',
        cancel_url: 'http://localhost:3000/',
        # cancel_url: 'http://connect-gorilla.com/'
      }
    )

    data = response.parsed_response
    render json: data
  end

end
