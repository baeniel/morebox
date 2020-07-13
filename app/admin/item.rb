ActiveAdmin.register Item do

  permit_params :title, :price, :image, :image2, :point

  index do
    selectable_column
    id_column
    column :title
    column :price
    column :point
    column :image do |item|
      image_tag(item.image_url, class: 'admin-index-image')
    end
    # column :image2
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :price
      f.input :point
      f.input :image
      # f.input :image2
    end
    f.actions
  end
end
