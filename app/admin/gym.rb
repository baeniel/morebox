ActiveAdmin.register Gym do
  permit_params :title, :purchase, :gorilla_purchase, :ultra_purchase, :protein_purchase

  action_item :gorilla_improve, only: :edit do
    link_to "고릴라 1박스 더!", gorilla_improve_admin_gym_path(gym), method: :put
  end

  action_item :ultra_improve, only: :edit do
    link_to "몬스터울트라 1박스 더!", ultra_improve_admin_gym_path(gym), method: :put
  end

  action_item :protein_improve, only: :edit do
    link_to "프로틴 1박스 더!", protein_improve_admin_gym_path(gym), method: :put
  end

  member_action :gorilla_improve, method: :put do
    gym = Gym.find params[:id]
    gym.increment!(:gorilla_purchase, 20)
    redirect_to admin_gyms_path
  end

  member_action :ultra_improve, method: :put do
    gym = Gym.find params[:id]
    gym.increment!(:ultra_purchase, 24)
    redirect_to admin_gyms_path
  end

  member_action :protein_improve, method: :put do
    gym = Gym.find params[:id]
    gym.increment!(:protein_purchase, 20)
    redirect_to admin_gyms_path
  end
end
