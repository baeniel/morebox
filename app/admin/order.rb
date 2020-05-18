ActiveAdmin.register Order do
  permit_params :user_id, :item_id, :number

  index do
    selectable_column
    id_column

    column "item" do |i|
      i.item.title
    end
    column "user" do |u|
      u.user.phone
    end
    column "gym" do |g|
      g.gym.title
    end
    column :number
    column :created_at
    actions
  end

end
