class Point < ApplicationRecord
  belongs_to :user
  belongs_to :gym, optional: true
  belongs_to :sub_item, optional: true
  has_one :order, dependent: :nullify
  enum point_type: %i(charged used)

  after_create :set_stock

  def set_stock
    if self.sub_item_id.present?
      #self.user.gym.gyms_sub_items.find_by(sub_item: sub_item).decrement!(:quantity)
      gym = self.gym
      gym.gyms_sub_items.find_by(sub_item: sub_item).decrement!(:quantity)
      #TODO
    # elsif self.charged?
    #   self.user.referrer != "-"
    #   self.update(amount: self.item&.price * 1.05) if self.item&.exists?
      date_start = DateTime.now
      date_end = date_start - 7.days

      gym.gyms_sub_items.each do |gym_sub_item|
        average_daily_consumption_speed = gym.points.where(point_type: :used, sub_item: gym_sub_item.sub_item, created_at: date_end..date_start).count / 7.0
        date_to_be_maintained = 3

        if (gym_sub_item.quantity <= average_daily_consumption_speed * date_to_be_maintained) && (gym_sub_item.sub_item == self.sub_item)
          receiver = '010-5605-3087'
          receiverName = '박진배'
          subject = "재고 주문 알람"
          contents = "#{gym.title}의 #{gym_sub_item.sub_item.title} 재고가 #{gym_sub_item.quantity}개 남았습니다. 주문해주세요"
          stock_alarm = MessageAlarmService.new(receiver, receiverName, subject, contents)
          stock_alarm.send_message
        end
      end
    end
  end

end
