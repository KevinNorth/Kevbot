require 'turntabler'
require_relative 'config.rb'
require_relative 'commands/command.rb'

config = KevbotConfiguration.load_config

puts config["email"]

Turntabler.run do
  client = Turntabler::Client.new(config['email'], config['password'], :room => config['room'], :reconnect => true, :reconnect_wait => 30)

  client.on :user_spoke do |message|
    string = message.content
  	puts "recieved command #{string}"

  	#Respond to chat commands
  	for command in Command.GetAllCommands()
  		if command.check_command_name(string)
  			puts "running command #{string}"
  			params = command.get_parameters(string)
  			command.execute(params, client)
  			break
  		end
  	end
  end
end
