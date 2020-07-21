class SubItem < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_and_belongs_to_many :gyms, join_table: :gyms_sub_items
  has_many :points, dependent: :nullify
  # accepts_nested_attributes_for :gyms
end
