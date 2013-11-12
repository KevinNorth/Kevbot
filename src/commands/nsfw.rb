require_relative '../kevbot_state.rb'
require_relative 'command.rb'

class NsfwCommand
include Command

  # Returns an array of strings that can be used as command names in the chat.
  def names()
    names = []
    names.push "nsfw"
    return names
  end

  # execute(string) - return nothing
  # Submits a complaint that a song is innapropriate.
  # Skips the current song if enough people have complained.
  def execute(parameter, user, client, state)
    room = client.room
    complainers = state.nsfw_complainers
    num_listeners = room.listeners.size

    if room.current_song
      unless complainers.include? user
        complainers.push user

        case num_listeners
        when 2 # The only users are the robot and the complainer
          room.say "You're the only one in here."
          room.say "I promise you can't offend me. I'm a robot."
        when 3 # One listener
          room.say "@#{room.current_dj.name}, nsfw music is not allowed in this room. Please skip your song."
        else # Multiple listeners
          num_complainers = complainers.size
          complaint_limit = calculate_complaint_limit(num_listeners)
          if num_complainers >= complaint_limit
            room.current_song.skip
          else
            room.say "If #{complaint_limit - num_complainers} more people complain, I'll skip the song."
          end
        end
      end
    end
  end

  # Calculates how many people need to complain about a song
  # before it will be skipped
  def calculate_complaint_limit(num_listeners)
    num_listeners -= 2 # don't count the DJ and the bot
    case num_listeners
    when 2
      return 2
    when 3..5
      return 3
    when 6..7
      return 4
    when 8..14
      return 5
    when 15..20
      return 6
    else
      return num_listeners / 3
    end
  end

  # help_message() - return a string
  # Returns a message that can be used with the `help` command to describe what the command does to users.
  def help_message()
    return "If enough users use /nsfw on this song, I'll skip it for being not safe for work."
  end
end
