require_relative '../kevbot_state.rb'
require_relative 'command.rb'

class RulesCommand
include Command

  # Returns an array of strings that can be used as command names in the chat.
  def names()
    names = []
    names.push "rules"
    return names
  end

  # Tells the room rules.
  def execute(parameter, user, client, state)
    room = client.room
    room.say "These are the room rules:"
    room.say ":small_blue_diamond:Don't go AFK on deck."
    room.say ":small_blue_diamond:This room uses a queue. Use /q to check it and /q+ to add yourself."
    room.say ":small_blue_diamond:If someone plays something offensive, you can use the /nsfw command to request a skip."
  end

  # help_message() - return a string
  # Returns a message that can be used with the `help` command to describe what the command does to users.
  def help_message()
    return 'I\'ll tell you the room rules.'
  end
end
