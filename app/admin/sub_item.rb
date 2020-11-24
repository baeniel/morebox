ActiveAdmin.register SubItem do
  permit_params :title, :image, :point, :category_id, :description, :calorie, :carbo, :protein, :fat, :link, :price, :is_purchase, :min_quantity, :order_batch
  filter :created_at

  index do
    selectable_column
    id_column
    column :title
    column :image do |sub_item|
      image_tag(sub_item.image_url, class: 'admin-index-image') if sub_item.image_url
    end
    column :calorie
    column :carbo
    column :protein
    column :fat
    column :point
    column :food
    column :price
    column :category
    column :sub_item_type
    column :is_purchase
    column :description
    column :min_quantity
    column :order_batch
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
      f.input :calorie
      f.input :carbo
      f.input :protein
      f.input :fat
      f.input :link
      f.input :price
      f.input :is_purchase
      f.input :min_quantity
      f.input :order_batch
    end
    f.actions
  end
end
