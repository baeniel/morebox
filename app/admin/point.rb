ActiveAdmin.register Point do
  permit_params :amount, :point_type, :user_id, :sub_item_id

  index do
    selectable_column
    id_column
    column :amount
    column :point_type
    column :sub_item
    column "user" do |u|
      u.user.phone
    end
    column "gym" do |u|
      u.user.gym
    end
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :amount
      f.input :point_type
      f.input :user_id, as: :select, collection: User.all.map{|u| [u.phone, u.id]}
      f.input :sub_item_id, as: :select, collection: SubItem.all.map{|s| [s.title, s.id]}
    end
    f.actions
  end
end
