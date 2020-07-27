class PointsController < ApplicationController
  before_action :authenticate_user!

  def create
    @title = "결제에 실패햐였습니다."
    @body = "다시 선택하시거나 결제해주세요!"
    begin
      if (sub_item_params = params.dig(:sub_item))
        if sub_item_params.values.all? { |value| value == "0" }
          @title = "아무 것도 선택되지 않았습니다."
          @body = "다시 선택해주세요!"
          raise
        end
        sub_items = SubItem.find(sub_item_params.keys)
        total_price = sub_items.inject(0){|sum, sub_item| sum + (sub_item.point * sub_item_params.dig(sub_item.id.to_s).to_i)}
        arr = []

        if total_price <= current_user.remained_point
          Point.transaction do
            sub_items.each do |sub_item|
              sub_item_params.dig(sub_item.id.to_s).to_i.times.each do
                Point.create(user: current_user, point_type: :used, amount: sub_item.point, sub_item: sub_item)
                arr << sub_item
              end
            end
          end

          unless current_user.remained_point > 2000
            receiver = current_user.phone
            receiverName = current_user.phone.last(4)
            contents = "[MoreBox]\n"+"헬스장 오기 전에 미리 결제하세요:)\n잔여포인트: #{current_user.remained_point}p\nhttps://morebox.co.kr"
            payment_alarm = MessageAlarmService.new(receiver, receiverName, contents)
            payment_alarm.send_message
          else
            templateCode = '020070000275'
            content = "[MoveMore]\n"+current_user.phone.last(4)+"님의 "+arr.map { |arr| arr.title }.flatten.join(' ')+" 꺼내기가 완료되었습니다.\n\n현재 잔여 포인트: "+current_user.remained_point.to_s+"P\n\n문의사항 있으시면 무브모어 카카오톡 채널로 편하게 연락주시기 바랍니다.\n\n무브모어 카카오톡 채널: @무브모어 @movemore"
            receiver = current_user.phone
            receiverName = current_user.phone.last(4)
            point_use_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
            point_use_alarm.send_alarm
          end
        elsif current_user.remained_point == 0
          # 처음 회원가입하는 0포인트
          @title = "카카오페이로 간편하게 결제하세요!"
          @body = "노란색 충전버튼을 눌러주세요:)"
          raise
        else
          # 포인트가 부족할 때
          @title = "포인트를 초과하셨습니다."
          @body = "다시 선택하시거나 결제해주세요!"
          raise
        end
      else
        #파라미터 없을때
        raise
      end
      @title = "이제 냉장고에서 꺼내 드세요!"
      @body = "2초 후 자동로그아웃 됩니다."
      @result = true
    rescue Exception => ex
      @result = false
    end
    respond_to do |format|
      format.js { render 'create' }
    end
  end

end
