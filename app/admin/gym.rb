ActiveAdmin.register Gym do
  permit_params :title, :gorilla_stock, :ultra_stock, :protein_stock, :gorilla_purchase, :ultra_purchase, :protein_purchase, sub_item_ids: []

  action_item :gorilla_improve, only: :edit do
    link_to "고릴라 1박스 더!", gorilla_improve_admin_gym_path(gym), method: :put
  end

  action_item :ultra_improve, only: :edit do
    link_to "몬스터울트라 1박스 더!", ultra_improve_admin_gym_path(gym), method: :put
  end

  action_item :protein_improve, only: :edit do
    link_to "프로틴 1박스 더!", protein_improve_admin_gym_path(gym), method: :put
  end

  action_item :protein_improve, only: :edit do
    link_to "과일 1박스 더!", fruit_improve_admin_gym_path(gym), method: :put
  end

  member_action :gorilla_improve, method: :put do
    gym = Gym.find params[:id]
    gym.increment!(:gorilla_purchase, 20)
    redirect_to admin_gyms_path
  end

  member_action :ultra_improve, method: :put do
    gym = Gym.find params[:id]
    gym.increment!(:ultra_purchase, 24)
    redirect_to admin_gyms_path
  end

  member_action :protein_improve, method: :put do
    gym = Gym.find params[:id]
    gym.increment!(:protein_purchase, 20)
    redirect_to admin_gyms_path
  end

  member_action :fruit_improve, method: :put do
    gym = Gym.find params[:id]
    gym.increment!(:purchase_1, 10)
    redirect_to admin_gyms_path
  end

  index do
    selectable_column
    id_column

    column :title
    column :gorilla_stock
    column :ultra_stock
    column :protein_stock
    column :stock_1
    column :stock_2
    column :stock_3
    column :stock_4
    column :gorilla_purchase
    column :ultra_purchase
    column :protein_purchase
    column :purchase_1
    column :purchase_2
    column :purchase_3
    column :purchase_4

    # column :sub_items do |gym|
    #   table_for gym.sub_items.order(created_at: :desc) do
    #     column do |sub_item|
    #       sub_item.title
    #     end
    #   end
    # end

    column :created_at
    actions
  end

  # form do |f|
  form html: { multipart: true } do |f|
    f.inputs do
      f.input :title
      f.input :gorilla_stock
      f.input :ultra_stock
      f.input :protein_stock
      f.input :stock_1
      f.input :gorilla_purchase
      f.input :ultra_purchase
      f.input :protein_purchase
      f.input :purchase_1
      f.input :sub_items, as: :check_boxes, collection: SubItem.all
    end
    f.actions
  end
end
