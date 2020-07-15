ActiveAdmin.register Order do
  permit_params :user_id, :point_id, :status, :gym_id, :item_id

  index do
    selectable_column
    id_column
    column "user" do |u|
      u&.user&.phone
    end
    column "point" do |p|
      p&.point&.amount
    end
    column :gym
    column :item
    column :status
    column :created_at
    column :paid_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :point_id, as: :select, collection: Point.all.map{ |p| p.id }
      f.input :gym_id, as: :select, collection: Gym.all.map{ |g| [g.title, g.id] }
      f.input :item_id, as: :select, collection: Item.all.map{ |i| [i.title, i.id] }
      f.input :status
      f.input :user_id, as: :select, collection: User.all.map{|u| [u.phone, u.id]}
      # f.input :paid_at
    end
    f.actions
  end

end
