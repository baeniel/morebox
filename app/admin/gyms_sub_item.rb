ActiveAdmin.register GymsSubItem do
  menu label: "재고관리" 

  permit_params :sub_item_id, :quantity, gym_ids: []

  controller do
    def scoped_collection
      if current_admin_user.has_role? :gym
        GymsSubItem.where(gym: Gym.where(title: current_admin_user.gym_list))
      else
        super
      end
    end
  end

  batch_action "동기화" do |ids|
    batch_action_collection.find(ids).each do |gyms_sub_item|
      gyms_sub_item.update order_quantity: gyms_sub_item.quantity
    end
    redirect_to collection_path, alert: "동기화 완료되었습니다."
  end

  action_item :new_purchase, only: :index do
    link_to "발주요청", new_admin_purchase_path if current_admin_user&.has_role? :gym
  end


  index do
    selectable_column if current_admin_user.has_role? :admin
    column "지점명", :gym
    column "제품", :sub_item
    column "재고수량", :quantity
    column "발주량", :order_quantity if current_admin_user.has_role? :admin
    column "최종업데이트시각", :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :gym if current_admin_user.has_role? :admin
      f.input :sub_item if current_admin_user.has_role? :admin
      f.input :quantity, label: "재고수량"
      f.input :order_quantity if current_admin_user.has_role? :admin
    end
    f.actions
  end

  show do
    attributes_table do
      row("지점명") { |g| g.gym.title }
      row("제품") { |g| g.sub_item }
      row("재고수량") { |g| g.quantity }
      row("발주량") { |g| g.order_quantity } if current_admin_user.has_role? :admin
    end
  end
end
