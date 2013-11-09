require 'turntabler'
require 'Config'

config = Config.load_config

Turntabler.run(EMAIL, PASSWORD, :room => ROOM, :reconnect => true, :reconnect_wait => 30) do
  on :user_spoke do |message|
    # Respond to "/hello" command
    if (message.content =~ /^\/hello$/)
      room.say("Hey! How are you @#{message.sender.name}?")
    end
  end
end