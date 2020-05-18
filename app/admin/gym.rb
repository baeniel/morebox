ActiveAdmin.register Gym do
  permit_params :title, :purchase, :gorilla_purchase, :ultra_purchase, :protein_purchase
end
