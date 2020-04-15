ActiveAdmin.register User do
  permit_params :password, :password_confirmation, :payment, :fit_center, :phone, :username

  index do
    selectable_column
    id_column
    column :username
    column :phone
    column :fit_center
    # column "gym" do |g|
    #   g.gym&.title
    # end
    column :payment
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :username
      row :phone
      row :fit_center
      # row :gym
      row :payment
      row :created_at
    end
  end

  form do |f|
    f.inputs do
      f.input :username
      f.input :phone
      f.input :fit_center
      # f.input :gym
      f.input :payment
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end


end
