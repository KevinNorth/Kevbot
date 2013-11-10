require_relative 'queue/room_queue.rb'

# Keeps track of the current state of the robot.
# These are basically global variables. To keep the code half-way sane,
# I put them all into the same class. For example, this means that we
# pass the state around, avoiding singleton pattern code smells by
# directly accessing the variable's values.
class KevbotState
  # When the robot is told to /dance, this keeps track of its behavior
  attr_accessor :active_dance

  # When the robot is told to /dance, this keeps track its avatar before
  # any potential avatar changes
  attr_accessor :previous_avatar_id

  # This keeps track of the DJ queue
  attr_reader :room_queue

  # This keeps track of all of the users who have complained that a song
  # is inappropriate.
  attr_accessor :nsfw_complainers

  def initialize(client)
    @active_dance = nil
    @previous_avatar_id = client.user.avatar.id
    @room_queue = RoomQueue.new
    @nsfw_complainers = []
  end
end
