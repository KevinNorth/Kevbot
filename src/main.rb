require 'turntabler'
require_relative 'config.rb'

config = KevbotConfiguration.load_config

puts config["email"]

Turntabler.run(config['email'], config['password'], :room => config['room'], :reconnect => true, :reconnect_wait => 30) do
  on :user_spoke do |message|
    # Respond to "/hello" command
    if (message.content =~ /^\/hello$/)
      room.say("Hey! How are you @#{message.sender.name}?")
    end
  end
end