ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, role_ids: [], gym_list: []

  #
  index do
    selectable_column
    id_column
    column :email
    column :gym_list
    column :roles
    column :created_at
    actions
  end
  #
  # filter :email
  # filter :current_sign_in_at
  # filter :sign_in_count
  # filter :created_at
  #
  form do |f|
    f.inputs do
      f.input :email
      f.input :password if (action_name == "new")
      f.input :password_confirmation if (action_name == "new")
      f.input :roles

      f.input :gym_list, as: :select, multiple: :true, collection: Gym.all.pluck(:title)
    end
    f.actions
  end

end
