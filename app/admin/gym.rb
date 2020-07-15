ActiveAdmin.register Gym do
  filter :created_at
  permit_params :title, sub_item_ids: []

  index do
    selectable_column
    id_column
    column :title
    column :created_at
    actions
  end

  # form do |f|
  form html: { multipart: true } do |f|
    f.inputs do
      f.input :title
      f.input :sub_items, as: :check_boxes, collection: SubItem.all
    end
    f.actions
  end
end
