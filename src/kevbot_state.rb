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

  # This keeps track of when each user was last active.
  attr_accessor :last_activity

  # This keeps track of which AFK DJs have been reminded to stay active
  # on deck
  attr_accessor :sent_dj_reminders

  # This keeps track of when a DJ slot became available so that
  # users in queue who take too long to get on deck can be removed
  # from the queue
  attr_accessor :time_deck_slot_became_available

  # Thie keeps track of whether the user at the front of the queu has
  # been reminded to claim his/her spot
  attr_accessor :sent_queue_reminder

  def initialize(client)
    @active_dance = nil
    @previous_avatar_id = client.user.avatar.id
    @room_queue = RoomQueue.new
    @nsfw_complainers = []
    @last_activity = {}
    @sent_dj_reminders = {}

    for user in client.room.listeners
      @last_activity[user] = Time.now
      @sent_dj_reminders[user] = false
    end

    @time_deck_slot_became_available = Time.now
    @sent_queue_reminder = false
  end
end
