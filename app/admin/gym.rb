ActiveAdmin.register Gym do
  action_item only: %i(index) do
    link_to '통합 대시보드', total_dashboard_gyms_path
  end
  action_item only: %i(index) do
    link_to '그래프보기', gyms_path
  end

  filter :created_at
  permit_params :title, sub_item_ids: []
  index do
    selectable_column
    id_column
    column :title
    column :created_at
    actions
  end

  form html: { multipart: true } do |f|
    f.inputs do
      f.input :title
      f.input :sub_items, as: :check_boxes, collection: SubItem.all
    end
    f.actions
  end
end
