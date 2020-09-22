class PointsController < ApplicationController
  before_action :authenticate_user!

  def create
    @title = "결제에 실패하였습니다."
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
                point = Point.create(user: current_user, point_type: :used, amount: sub_item.point, sub_item: sub_item, remain_point: 0)
                point.update!(remain_point: current_user.remained_point)
                arr << sub_item
              end
            end
          end
          templateCode = '020070000275'
          content = "[MoveMore]\n"+current_user.phone.last(4)+"님의 "+arr.map { |arr| arr.title }.flatten.uniq.join(', ')+" 꺼내기가 완료되었습니다.\n\n현재 잔여 포인트: "+current_user.remained_point.to_s+"P\n\n문의사항 있으시면 무브모어 카카오톡 채널로 편하게 연락주시기 바랍니다.\n\n무브모어 카카오톡 채널: @무브모어 @movemore"
          receiver = current_user.phone
          receiverName = current_user.phone.last(4)
          point_use_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
          point_use_alarm.send_alarm
        else
          subitem_info = {}
          sub_item_params.each do |key, value|
            subitem_info[key] = value.to_i
          end
          @subitem_info = subitem_info
          @result = "charge"
          raise
        end
      else
        #파라미터 없을때
        raise
      end
      @title = "이제 냉장고에서 꺼내 드세요!"
      @body = "5초 후 자동로그아웃 됩니다."
      @result = true
    rescue Exception => ex
      @result ||= false
    end
    respond_to do |format|
      format.js { render 'create' }
    end
  end

end
