# This module is the primary module for chat commands in Kevbot.
module Command
	require_relative 'help.rb'
	require_relative 'avatar.rb'
	require_relative 'dance.rb'
	require_relative 'list_commands.rb'
	require_relative 'add_to_queue.rb'
	require_relative 'remove_from_queue.rb'
	require_relative 'check_queue.rb'
	require_relative 'nsfw.rb'

	def self.GetAllCommands()
		commands = []
		commands.push Help.new
		commands.push Avatar.new
		commands.push Dance.new
		commands.push ListCommands.new
		commands.push AddToQueue.new
		commands.push RemoveFromQueue.new
		commands.push CheckQueue.new
		commands.push Nsfw.new
		return commands
	end

	# Every command should implement these three methods:
	#
	# names() - return an array of strings
	# Returns an array of strings that can be used as command names in the chat.
	#
	# execute(params, user, client, state) - return nothing
	# Executes the command's effects.
	# Recieves:
	#   anything in the chat message after the command name
	#   the user who sent the message
	#   the current client
	#   the current KevbotState
	#
	# help_message() - return a string
	# Returns a message that can be used with the `help` command to describe what the command does to users.

	# Compares chat messages to the names a command can have to see if the chat message was intended
	# to invoke this command.
	#
	# Param: chat_string
	# A string another user entered in the chat that might be a command
	#
	# Returns: `true` if the chat string matches one of the names for this command, `false` otherwise
	def check_command_name(chat_string)
		for name in names.sort_by
			if /^(\s\ )*(\/)?#{Regexp.quote(name)}/ =~ chat_string
				return true
			end
		end

		return false
	end

	# Takes a chat command from another user and pulls out the portion of the command that can
	# serve as command parameters
	#
	# Param: command_string
	# The chat command in its entirety
	#
	# Returns: Everything after the command name in the chat command so that it can be used
	# as parameters when the command is executed
	def get_parameters(command_string)
		for name in names.sort_by{|name| name.size}
			scrape = command_string.match(/^(\s\ )*(\/)?#{Regexp.quote(name)}(?<params>(.)*)$/)
			if scrape
				return scrape["params"]
			end
		end

		return ""
	end
end
