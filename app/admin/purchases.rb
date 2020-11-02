ActiveAdmin.register Purchase, label: "발주"  do
  menu label: "발주" 
  scope -> {"전체"}, :all
  scope -> {"발주대기"}, :before
  scope -> {"발주완료"}, :done
  
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
  end

  batch_action "발주완료처리" do |ids|
    batch_action_collection.find(ids).each do |purchase|
      purchase.done!
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
    f.actions
  end
end
