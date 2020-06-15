ActiveAdmin.register SubItem do
  permit_params :title, :image, :point
  filter :created_at

  index do
    selectable_column
    id_column

    column :title
    column :image do |sub_item|
      image_tag(sub_item.image_url, class: 'admin-index-image')
    end
    column :point
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :image
      f.input :point
    end
    f.actions
  end
end
