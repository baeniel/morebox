ActiveAdmin.register User do

  permit_params :password, :password_confirmation, :fit_center, :phone, :gym_id, :email, :gender, :referrer, :user_type, :name, :target_weight, :target_date, :ideal_kcal, :ideal_carbo, :ideal_protein, :ideal_fat

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :referrer
    column :gender
    # column "item" do |i|
    #   i.item&.title
    # end
    column "gym" do |g|
      g.gym&.title
    end
    column :privacy
    column :marketing
    column :fit_center
    column :user_type
    # column :image do |user|
    #   image_tag(user.image_url, class: 'admin-index-image')
    # end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :phone
      row :gender
      row :created_at
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :phone
      f.input :fit_center
      f.input :user_type, as: :select, include_blank: false, selected: :fit_table
      f.input :gym, as: :select, include_blank: false, collection: Gym.all, selected: Gym.first
      f.input :name
      f.input :target_weight
      f.input :target_date
      f.input :ideal_kcal
      f.input :ideal_carbo
      f.input :ideal_protein
      f.input :ideal_fat
      # , input_html: {value: "2020-12-31"}
      # f.input :password
      # f.input :password_confirmation
    end
    f.actions
  end
end
