ActiveAdmin.register Post do
  index do
    selectable_column
    id_column
    column :post_type
    column :age
    column :height
    column :weight
    column :gender
    column :activity
    column :work_time
    column :work_count
    column :work_strength
    column :target_weight
    column :target_date
    column :lunch
    column :sickness
    column :name
    column :phone
    column :email
    column :period
    column :money
    actions
  end
end
