ActiveAdmin.register Order do
  permit_params :user_id, :point

  index do
    selectable_column
    id_column
    column "user" do |u|
      u.user.phone
    end
    column "point" do |p|
      p.point.amount
    end
    column :status
    column :created_at
    column :paid_at
    actions
  end

end
