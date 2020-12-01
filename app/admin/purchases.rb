ActiveAdmin.register Purchase, label: "발주"  do
  menu label: "발주"
  scope -> {"전체"}, :all
  scope -> {"발주대기"}, :before
  scope -> {"발주승인"}, :done
  scope -> {"발주거부"}, :deny

  controller do
    def show
      if current_admin_user.has_role? :gym
        redirect_to admin_purchases_path
      else
        super
      end
    end

    def scoped_collection
      if current_admin_user.has_role? :gym
        Purchase.where(gym: Gym.where(title: current_admin_user.gym_list))
      else
        super
      end
    end

    def create
      purchase = Purchase.new(purchase_params)
      if purchase.quantity < purchase.sub_item.min_quantity
        redirect_to new_admin_purchase_path(sub_item: purchase.sub_item), alert: "최소 주문수량은 #{purchase.sub_item.min_quantity}개 입니다. 다시 발주를 넣어주세요!"
      elsif purchase.sub_item.order_batch && (purchase.quantity % purchase&.sub_item&.order_batch != 0)
        redirect_to new_admin_purchase_path(sub_item: purchase.sub_item), alert: "발주 단위는 #{purchase.sub_item.order_batch}개 입니다. 다시 발주를 넣어주세요!"
      else
        purchase.save
        templateCode = '020110000009'
        content = "[MoreMarket]\n" + SubItem.find(params[:purchase][:sub_item_id]).title + params[:purchase][:quantity] + "개 발주요청이 완료되었습니다. 2시 이후의 발주요청은 다음 날 접수됩니다."
        receiver = User.find_by(gym: Gym.find_by(title: current_admin_user.gym_list.first), fit_center: 1).phone
        receiverName = current_admin_user.email
        purchase_ready_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
        purchase_ready_alarm.send_alarm

        templateCode = '020110000010'
        content = "[MoreMarket]\n" + current_admin_user.gym_list.first + "센터의 " + SubItem.find(params[:purchase][:sub_item_id]).title + params[:purchase][:quantity] + "개 발주 요청이 접수되었습니다."
        receiver = "01056053087"
        receiverName = "박진배"
        purchase_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
        purchase_alarm.send_alarm

        redirect_to admin_purchases_path, notice: "발주 요청이 완료되었습니다."
      end


    end

    def updated
    end

    private
    def purchase_params
      params.require(:purchase).permit(:gym_id, :sub_item_id, :quantity)
    end
  end

  batch_action "발주완료처리" do |ids|
    batch_action_collection.find(ids).each do |purchase|
      purchase.done!
      templateCode = '020110000011'
      content = "[MoreMarket]\n" + purchase.sub_item.title + purchase.quantity.to_s + "개 발주가 승인되었습니다. 곧 출고 예정입니다."
      receiver = User.find_by(gym: purchase.gym, fit_center: 1).phone
      receiverName = purchase.gym.title + " 대표님"
      purchase_approve_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
      purchase_approve_alarm.send_alarm
    end
    redirect_to collection_path, alert: "발주 승인했습니다."
  end

  batch_action "발주거부처리" do |ids|
    batch_action_collection.find(ids).each do |purchase|
      purchase.deny!
      templateCode = '020110000194'
      content = "[MoreMarket]\n" + purchase.sub_item.title + " 발주가 거부되었습니다. 더 이상 취급하지 않는 상품입니다. 문의사항 있으시면 관리자에게 연락해주세요!"
      receiver = User.find_by(gym: purchase.gym, fit_center: 1).phone
      receiverName = purchase.gym.title + " 대표님"
      purchase_deny_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
      purchase_deny_alarm.send_alarm
    end
    redirect_to collection_path, alert: "발주 거부했습니다."
  end

  index do
    selectable_column if current_admin_user.has_role? :admin
    column "지점명", :gym
    column "제품", :sub_item
    column "발주수량", :quantity
    column "상태", :status do |object|
      object.before? ? "발주대기" : "발주승인"
    end
    column "발주가능", :is_purchase
    column "생성 시간", :created_at
    column "최종 업데이트 시간", :updated_at
  end

  form do |f|
    f.inputs do
      f.input :gym, as: :select, collection: (current_admin_user.has_role?(:admin) ? Gym.all : Gym.where(title: current_admin_user.gym_list)), include_blank: false, label: "지점명"
      f.input :sub_item, as: :select, include_blank: false, collection: SubItem.where(is_purchase: 1), label: "제품", selected: params[:sub_item]
      f.input :quantity, placeholder: 40, label: "총발주수량(개)"
      f.input :status if current_admin_user.has_role? :admin
    end
    f.actions do
      f.action :submit, label: "발주요청"
      f.action :cancel, label: "취소하기"
    end
  end
end
