ActiveAdmin.register Post do
  index do
    selectable_column
    id_column
    column :age
    column :height
    column :weight
    column :gender
    column :activity
    column :work_time
    column :work_count
    column :target_weight
    column :target_date
    column :lunch
    column :name
    actions
  end
end
