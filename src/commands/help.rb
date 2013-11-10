require_relative '../kevbot_state.rb'
require_relative 'command.rb'

class HelpCommand
include Command

	# Returns an array of strings that can be used as command names in the chat.
	def names()
		names = []
		names.push "help"
		return names
	end

	# execute(string) - return nothing
	# Executes the command's effects. Recieves anything in the chat message after the
	def execute(parameter, user, client, state)
		room = client.room

		if (parameter == nil || parameter.strip == "")
			room.say help_message
      return
		end

		for command in Command.GetAllCommands
			for name in command.names
				if /#{Regexp.quote(name)}/i =~ parameter
					room.say(command.help_message)
					return
				end
			end
		end

		#If we get to this point, none of the commands have matched the parameter
		room.say("I don't have a command called \"#{parameter.strip}\".")
    room.say("Use /commands to see a list of all commands.")
	end

	# help_message() - return a string
	# Returns a message that can be used with the `help` command to describe what the command does to users.
	def help_message()
		return 'If you say (for example) "help dance", I\'ll tell you what the dance command does.'
	end
end
