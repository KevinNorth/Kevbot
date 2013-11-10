require_relative '../kevbot_state.rb'
require_relative 'dance/dance_details.rb'
require_relative 'command.rb'

class Dance
include Command
  @@current_dance_id = 0


  # Returns an array of strings that can be used as command names in the chat.
  def names()
    names = []
    names.push "dance"
    return names
  end

  # Sets the avatar, or returns a list of avatars that can be used
  def execute(parameter, client, state)
    active_dance = state.active_dance
    room = client.room

    if active_dance == nil
      current_dance_id += 1
      dances = DanceDetails.GetAllDances
      active_dance = dances[current_dance_id % dances.size]

      state.active_dance = active_dance

      room.say active_dance.response

      unless active_dance.wait_to_dance
        room.current_song.vote
      end

      if active_dance.change_avatar
        id = active_dance.avatar_options.sample
        for avatar in client.avatars
          if avatar.id == id
            if avatar.available?
              avatar.set id
            end
          end
        end
      end

    else # if there is already an active_dance

      if active_dance.wait_to_dance
        room.current_song.vote
      end

      if subsequent_dance_command_response
        room.say subsequent_dance_command_response
      end
    end
  end

  # help_message() - return a string
  # Returns a message that can be used with the `help` command to describe what the command does to users.
  def help_message()
    return 'I\'ll upvote the current song and say something terribly clever.'
  end
end