class Point < ApplicationRecord
  belongs_to :user
  belongs_to :gym, optional: true
  belongs_to :sub_item, optional: true
  has_one :order, dependent: :nullify
  enum point_type: %i(charged used)

  after_create :set_stock

  def set_stock
    if self.sub_item_id.present?
      self.user.gym.gyms_sub_items.find_by(sub_item: sub_item).decrement!(:quantity)
    end
  end

end
