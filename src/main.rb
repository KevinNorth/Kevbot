require 'turntabler'
require_relative "kevbot_state.rb"
require_relative 'commands/command.rb'
require_relative 'dance/dance.rb'

def record_user_activity(user, state)
  state.last_activity[user] = Time.now
  state.sent_dj_reminders[user] = false
end

def record_dj_spot_available(state)
  state.time_deck_slot_became_available = Time.now
  state.sent_queue_reminder = false
end

Turntabler.run do
  client = Turntabler::Client.new(ENV['EMAIL'], ENV['PASSWORD'], :room => ENV['ROOM'], :reconnect => true, :reconnect_wait => 30)
  state = KevbotState.new (client)

  client.on :heartbeat do
    room = client.room

    # Enforce that DJs should not go AFK on deck if the deck is full or there is a queue
    if (not state.room_queue.empty?) && (room.djs.count >= room.dj_capacity)
      for dj in client.room.djs
        # Don't count time AFK before the last DJ got on deck
        dj_time_afk = Time.now - state.last_activity[dj]
        time_since_dj_got_on_deck = Time.now - state.time_newest_dj_got_on_deck

        seconds_away = dj_time_afk > time_since_dj_got_on_deck ? \
          time_since_dj_got_on_deck : dj_time_afk

        if seconds_away >= 900 && (not state.sent_dj_reminders[dj])
          room.say "Stay active on deck, @#{dj.name}"
          state.sent_dj_reminders[dj] = true
          puts state.sent_dj_reminders[dj]
        end
        if seconds_away >= 1200
          dj.remove_as_dj
        end
      end
    end

    # Enforce that AFK users lose their positions in the queue.
    queue = state.room_queue
    unless queue.empty? && (room.djs.count < room.dj_capacity)
      head = queue.peek
      seconds_away = Time.now - state.time_deck_slot_became_available
      if (seconds_away > 90) && (not state.sent_queue_reminder)
        room.say "If you don't get on deck soon, @#{head.name}, you'll lose your queue spot."
      end
      if seconds_away > 150
        room.say "@#{head.name}, you took too long to get on deck."
        record_dj_spot_available state
        queue.pull_user

        if queue.empty?
          room.say "The queue is empty, so anybody can get on deck!"
        else
          room.say "@#{queue.peek}, you can get on deck now!"
        end
      end
    end
  end

  client.on :user_spoke do |message|
    record_user_activity message.sender, state

    unless message.sender == client.user
      string = message.content
    	puts "recieved command #{string}"

    	#Respond to chat commands
    	for command in Command.GetAllCommands()
    		if command.check_command_name(string)
    			puts "running command #{string}"
    			params = command.get_parameters(string)
    			command.execute(params, message.sender, client, state)
    			break
    		end
    	end
    end
  end

  client.on :song_started do |song|
    # Remove the active dance at the end of the song
    state.active_dance = nil

    # Clear the nsfw complainers collection
    state.nsfw_complainers = []

    # Reset number of snags
    state.num_snags = 0
  end

  client.on :song_ended do |song|
    # Change back avatar if it was changed using a dance command
    id = state.previous_avatar_id
    for avatar in client.avatars
      if avatar.id == id
        if avatar.available?
          avatar.set
        end
      end
    end

    # State song stats
    client.room.say "Stats for #{song.title}: #{song.up_votes_count} :arrow_up: #{song.down_votes_count} :arrow_down: #{state.num_snags} :heart_decoration:"
  end

  client.on :user_entered do |user|
    client.room.say "Welcome to #{client.room.name}, @#{user.name}!"
    record_user_activity user, state
  end

  client.on :user_left do |user|
    state.room_queue.remove_user user
    state.last_activity.delete user
    state.sent_dj_reminders.delete user
  end

  client.on :user_booted do |user|
    state.room_queue.remove_user user
  end

  client.on :dj_added do |user|
    record_user_activity user, state
    state.time_newest_dj_got_on_deck = Time.now

    room = client.room
    queue = state.room_queue
    if queue.can_user_dj? user
      queue.remove_user user
    else
      user.remove_as_dj
      if queue.is_user_in_queue? user
        room.say "Please wait your turn, @#{user.name}!"
      else
        room.say "@#{user.name}, if you'd like to DJ, please add yourself to the queue."
        room.say "Use /q? to check the queue and /q+ to add yourself."
      end
    end

    # Reset the queue timer for the next person in queue
    if (room.djs.count < room.dj_capacity)
      record_dj_spot_available state
    end
  end

  client.on :dj_removed do |user|
    record_user_activity user, state
    record_dj_spot_available state

    unless state.room_queue.empty?
      next_dj = state.room_queue.peek
      room.say "@#{next_dj.name}, you can get on deck now!"
    end
  end

  client.on :song_voted do |song|
    for vote in song.votes
      record_user_activity vote.user, state
    end
  end

  client.on :song_snagged do |snag|
    record_user_activity snag.user, state
    state.num_snags += 1
  end
end
