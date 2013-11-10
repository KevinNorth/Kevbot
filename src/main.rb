require 'turntabler'
require_relative 'config.rb'
require_relative "kevbot_state.rb"
require_relative 'commands/command.rb'
require_relative 'commands/dance/dance_details.rb'

def user_left(user, state)
  state.room_queue.remove_user user
end

def dj_attempted_to_get_on(user, state, room)
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
end

def dj_stopped(user, state, room)
  unless state.room_queue.empty?
    next_dj = state.room_queue.peek
    room.say "@#{next_dj.name}, you can get on deck now!"
  end
end

config = KevbotConfiguration.load_config

Turntabler.run do
  client = Turntabler::Client.new(config['email'], config['password'], :room => config['room'], :reconnect => true, :reconnect_wait => 30)
  state = KevbotState.new (client)

  client.on :user_spoke do |message|
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

    # Remove the active dance at the end of the song
    state.active_dance = nil
  end

  client.on :user_left do |user|
    user_left user, state
  end

  client.on :user_booted do |user|
    user_left user, state
  end

  client.on :dj_added do |user|
    dj_attempted_to_get_on user, state, client.room
  end

  client.on :dj_removed do |user|
    dj_stopped user, state, client.room
  end
end
