ActiveAdmin.register Point do
  permit_params :amount, :point_type, :user_id

  index do
    selectable_column
    id_column
    column :amount
    column :point_type
    column "user" do |u|
      u.user.phone
    end
    column :created_at
    actions
  end
end
