class PointsController < ApplicationController
  before_action :authenticate_user!
  # before_action :check_own_tablet

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
                point = Point.create(user: current_user, point_type: :used, amount: sub_item.point, sub_item: sub_item, remain_point: 0, gym: current_gym)
                point.update(remain_point: current_user.remained_point)
                arr << sub_item
              end
            end
          end
          templateCode = '020100000009'
          content = "[MoreMarket]\n"+current_user.phone.last(4)+"님의 "+arr.map { |arr| arr.title }.flatten.uniq.join(', ')+" 꺼내기가 완료되었습니다.\n\n현재 잔여 포인트: "+current_user.remained_point.to_s+"P\n\n문의사항 있으시면 모어마켓 카카오톡 채널로 편하게 연락주시기 바랍니다.\n\n모어마켓 카카오톡 채널: @모어마켓"
          receiver = current_user.phone
          receiverName = current_user.phone.last(4)
          point_use_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
          point_use_alarm.send_alarm

          if ["움짐피트니스", "포이나짐", "얼티밋크로스핏", "쿠타짐 영등포", "에이짐휘트니스", "MADFIT", "HN휘트니스", "팀레드", "예스휘트니스", "공감휘트니스"].include? current_gym.title
            templateCode = '020100000654'
            content = current_user.phone.last(4) + "님의 " + arr.map { |arr| arr.title }.flatten.uniq.join(', ') + " 꺼내기가 완료되었습니다."
            receiver = User.find_by(gym: current_gym, fit_center: 1).phone
            receiverName = current_gym.title + "대표님"
            use_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
            use_alarm.send_alarm
          end

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

  private
  def check_own_tablet
    redirect_to root_path unless check_gym_tablet
  end

end
