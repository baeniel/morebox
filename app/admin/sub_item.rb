ActiveAdmin.register SubItem do
  permit_params :title, :image
  filter :created_at

  index do
    selectable_column
    id_column

    column :title
    column :image do |sub_item|
      image_tag(sub_item.image_url, class: 'admin-index-image')
    end
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :image
    end
    f.actions
  end
end
