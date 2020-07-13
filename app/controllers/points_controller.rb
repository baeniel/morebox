class PointsController < ApplicationController
  before_action :authenticate_user!

  def create
    @title = "결제에 실패햐였습니다."
    @body = "다시 선택하시거나 결제해주세요!"
    begin
      if (sub_item_params = params.dig(:sub_item))
        sub_items = SubItem.find(sub_item_params.keys)
        total_price = sub_items.inject(0){|sum, sub_item| sum + (sub_item.point * sub_item_params.dig(sub_item.id.to_s).to_i)}

        if total_price <= current_user.remained_point
          Point.transaction do
            sub_items.each do |sub_item|
              sub_item_params.dig(sub_item.id.to_s).to_i.times.each do
                Point.create(user: current_user, point_type: :used, amount: sub_item.point, sub_item: sub_item)
              end
            end
          end
        else
          # 포인트 없을 때
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
    rescue
      @result = false
    end
    respond_to do |format|
      format.js { render 'create' }
    end
  end

end
