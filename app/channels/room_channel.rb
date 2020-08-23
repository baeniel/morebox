class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from User.find_by(id: params['user_id']) if params['user_id'].present?
    stream_from "room_#{params['user_id']}" if params['user_id'].present?
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
