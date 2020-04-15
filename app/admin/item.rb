ActiveAdmin.register Item do

  permit_params :title, :price, :image

  index do
    selectable_column
    id_column
    column :title
    column :price
    column :image do |item|
      image_tag(item.image_url, class: 'admin-index-image')
    end
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :price
      f.input :image
    end
    f.actions
  end
end
