require_relative 'queue/room_queue.rb'

class KevbotState
  attr_accessor :active_dance
  attr_accessor :previous_avatar_id
  attr_reader :room_queue

  def initialize(client)
    @active_dance = nil
    @previous_avatar_id = client.user.avatar.id
    @room_queue = RoomQueue.new
  end
end
