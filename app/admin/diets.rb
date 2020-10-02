ActiveAdmin.register Diet do
  controller do
    def permitted_params
      params.permit!
    end
  end
  index do
    selectable_column
    id_column
    column :start_calorie
    column :end_calorie
    column :purpose
    column :body
    column :snack
    column :sub_items do |diet| diet.sub_items.map{|sub_item| sub_item.title}.join(", ") end
    actions
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
