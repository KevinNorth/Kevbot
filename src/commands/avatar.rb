require_relative 'command.rb'

class Avatar
include Command

  # Returns an array of strings that can be used as command names in the chat.
  def names()
    names = []
    names.push "avatar"
    return names
  end

  # Sets the avatar, or returns a list of avatars that can be used
  def execute(parameter, client)
    if (parameter == nil || parameter.strip == "")
      ids = []
      for avatar in client.avatars
        if avatar.available?
          ids.push avatar.id
        end
      end
      client.room.say(ids.join(', '))
    else
      id = parameter.strip.to_i
      for avatar in client.avatars
        if avatar.id == id
          if avatar.available?
            avatar.set
          end
        end
      end
    end
  end

  # help_message() - return a string
  # Returns a message that can be used with the `help` command to describe what the command does to users.
  def help_message()
    return 'Sets my avatar. Use the command with no options to see a list of avatar ids.'
  end
end
