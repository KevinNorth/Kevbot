require 'turntabler'
require_relative 'config.rb'
require_relative "kevbot_state.rb"
require_relative 'commands/command.rb'
require_relative 'commands/dance/dance_details.rb'


config = KevbotConfiguration.load_config

puts config["email"]

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
end
