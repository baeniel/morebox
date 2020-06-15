ActiveAdmin.register LineItem do
  permit_params :title, :quantity, :order_id, :temp

  index do
    selectable_column
    id_column
    column :title
    # column :image do |line_item|
    #   image_tag(line_item.image_url, class: 'admin-index-image')
    # end
    column :order_id
    column "username" do |line_item|
      line_item.order.user.phone
    end
    column "item" do |line_item|
      line_item.order.item
    end
    column :point
    column :quantity
    column :temp
    column :created_at
    actions
  end
end
