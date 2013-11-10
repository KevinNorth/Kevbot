require 'turntabler'
require_relative 'config.rb'
require_relative "kevbot_state.rb"
require_relative 'commands/command.rb'
require_relative 'commands/dance/dance_details.rb'

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

    # Clear the nsfw complainers collection
    state.nsfw_complainers = []
  end

  client.on :user_left do |user|
    state.room_queue.remove_user user
  end

  client.on :user_booted do |user|
    state.room_queue.remove_user user
  end

  client.on :dj_added do |user|
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

  client.on :dj_removed do |user|
    unless state.room_queue.empty?
      next_dj = state.room_queue.peek
      room.say "@#{next_dj.name}, you can get on deck now!"
    end
  end
end
