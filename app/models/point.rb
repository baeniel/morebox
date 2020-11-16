class Point < ApplicationRecord
  belongs_to :user
  belongs_to :gym, optional: true
  belongs_to :sub_item, optional: true
  has_one :order, dependent: :nullify
  enum point_type: %i(charged used)

  after_create :set_stock

  def set_stock
    if self.sub_item_id.present?
      gym = self.gym
      target_gym_sub_item = gym.gyms_sub_items.find_by(sub_item: self.sub_item)
      target_gym_sub_item.decrement!(:quantity)

      today = Date.current
      date_start = today - 7.days
      average_daily_consumption_speed = gym.points.where(point_type: :used, sub_item: self.sub_item, created_at: date_start..(today + 1.days)).count / 7.0
      date_to_be_maintained = 5

      if (target_gym_sub_item.quantity <= average_daily_consumption_speed * date_to_be_maintained) || (target_gym_sub_item.quantity <= 3)
        receiver = '010-5605-3087'
        receiverName = '박진배'
        subject = "재고 주문 알람"
        contents = "#{gym.title}의 #{self.sub_item.title} 재고가 #{target_gym_sub_item.quantity}개 남았습니다. #{average_daily_consumption_speed * 7}개 주문해주세요"
        stock_alarm = MessageAlarmService.new(receiver, receiverName, subject, contents)
        stock_alarm.send_message

        templateCode = '020110000219'
        content = "#{self.sub_item.title}의 재고가 곧 떨어질 예정입니다. 관리자에게 발주를 넣어주세요."
        receiver = User.find_by(gym: gym, fit_center: 1).phone
        receiverName = gym.title + "대표님"
        stock_gym_alarm = KakaoAlarmService.new(templateCode, content, receiver, receiverName)
        stock_gym_alarm.send_alarm
      end
    end
  end

end
