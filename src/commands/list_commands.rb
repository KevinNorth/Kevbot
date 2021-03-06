require_relative '../kevbot_state.rb'
require_relative 'command.rb'

class ListCommandsCommand
include Command

  # Returns an array of strings that can be used as command names in the chat.
  def names()
    names = []
    names.push "commands"
    return names
  end

  # Lists all commands
  def execute(parameter, user, client, state)
    commands = Command.GetAllCommands

    command_names = []

    for command in commands
      for name in command.names
        command_names.push name
      end
    end

    command_names.sort!

    client.room.say command_names.join(', ')
  end

  # help_message() - return a string
  # Returns a message that can be used with the `help` command to describe what the command does to users.
  def help_message()
    return 'I\'ll give you a list of all available commands.'
  end
end
