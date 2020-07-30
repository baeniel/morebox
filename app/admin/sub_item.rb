ActiveAdmin.register SubItem do
  permit_params :title, :image, :point, :category_id, :description
  filter :created_at

  index do
    selectable_column
    id_column
    column :title
    column :image do |sub_item|
      image_tag(sub_item.image_url, class: 'admin-index-image')
    end
    column :point
    column "category" do |c|
      c&.category.title
    end
    column :description
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :image
      f.input :point
      f.input :description
      f.input :category_id, as: :select, collection: Category.all.map{ |c| [c.title, c.id] }
    end
    f.actions
  end
end
