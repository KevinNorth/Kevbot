require_relative '../kevbot_state.rb'
require_relative 'command.rb'

class ListCommands
include Command

  # Returns an array of strings that can be used as command names in the chat.
  def names()
    names = []
    names.push "commands"
    return names
  end

  # Lists all commands
  def execute(parameter, client, state)
    commands = Command.GetAllCommands

    for command in commands
      client.room.say command.names.join('/')
    end
  end

  # help_message() - return a string
  # Returns a message that can be used with the `help` command to describe what the command does to users.
  def help_message()
    return 'I\'ll give you a list of all available commands.'
  end
end
