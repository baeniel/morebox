ActiveAdmin.register Purchase, label: "발주"  do
  menu label: "발주"
  scope -> {"전체"}, :all
  scope -> {"발주대기"}, :before
  scope -> {"발주승인"}, :done

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
      receiver = User.find_by(gym: Gym.find_by(title: current_admin_user.gym_list.first), fit_center: 1).phone
      receiverName = current_admin_user.email
      subject = "모어박스 발주요청"
      contents = "[MoreBox]\n" + SubItem.find(params[:purchase][:sub_item_id]).title + params[:purchase][:quantity] + "개 발주요청이 완료되었습니다.\n2시 이후의 발주요청은 다음 날 접수됩니다."
      purchase_ready_alarm = MessageAlarmService.new(receiver, receiverName, subject, contents)
      purchase_ready_alarm.send_message

      receiver = "01056053087"
      receiverName = "박진배"
      subject = "모어박스 발주요청"
      contents = current_admin_user.gym_list.first + "센터의 " + SubItem.find(params[:purchase][:sub_item_id]).title + params[:purchase][:quantity] + "개 발주 요청이 접수되었습니다."
      purchase_alarm = MessageAlarmService.new(receiver, receiverName, subject, contents)
      purchase_alarm.send_message

      redirect_to admin_purchases_path
    end

    def updated
    end
  end

  batch_action "발주완료처리" do |ids|
    batch_action_collection.find(ids).each do |purchase|
      purchase.done!
      receiver = User.find_by(gym: purchase.gym, fit_center: 1).phone
      receiverName = purchase.gym.title + " 대표님"
      subject = "모어박스 발주승인"
      contents = "[MoreBox]\n" + purchase.sub_item.title + purchase.quantity.to_s + "개 발주가 승인되었습니다.\n곧 출고 예정입니다."
      purchase_approve_alarm = MessageAlarmService.new(receiver, receiverName, subject, contents)
      purchase_approve_alarm.send_message
    end
    redirect_to collection_path, alert: "동기화 완료되었습니다."
  end

  index do
    selectable_column if current_admin_user.has_role? :admin
    column "지점명", :gym
    column "제품", :sub_item
    column "발주수량", :quantity
    column "상태", :status do |object|
      object.before? ? "발주대기" : "발주승인"
    end
    column "생성 시간", :created_at
    column "최종 업데이트 시간", :updated_at
  end



  form do |f|
    f.inputs do
      f.input :gym, as: :select, collection: (current_admin_user.has_role?(:admin) ? Gym.all : Gym.where(title: current_admin_user.gym_list)), include_blank: false, label: "지점명"
      f.input :sub_item, include_blank: false, label: "제품"
      f.input :quantity, label: "발주수량"
      f.input :status if current_admin_user.has_role? :admin
    end
    f.actions do
      f.action :submit, label: "발주요청"
      f.action :cancel, label: "취소하기"
    end
  end
end
