ActiveAdmin.register GymsSubItem do
  permit_params :gym_id, :sub_item_id, :quantity

  controller do
    def scoped_collection
      if current_admin_user.has_role? :gym
        GymsSubItem.where(gym: current_admin_user.gym)
      else
        super
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :start_calorie
      f.input :end_calorie
      f.input :purpose
      f.input :body
      f.input :snack
      f.input :sub_items
    end
    f.actions
  end

end
