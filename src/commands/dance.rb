require 'turntabler'
require_relative '../kevbot_state.rb'
require_relative 'dance/dance_details.rb'
require_relative 'command.rb'

class Dance
include Command
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

    unless room.current_song
      room.say "Play something, then ask me to dance!"
      return
    end

    if active_dance == nil
      dances = DanceDetails.GetAllDances
      active_dance = dances[[48, 44].sample]  # .sample

      state.active_dance = active_dance

      room.say active_dance.response

      unless active_dance.wait_to_dance
        upvote_song room
      end

      if active_dance.change_avatar

        id = active_dance.avatar_options.sample
        # Make sure we don't pick the same avatar if there are options
        if active_dance.avatar_options.size > 1
          while client.user.avatar.id == id do
            id = active_dance.avatar_options.sample
          end
        end

        for avatar in client.avatars
          if avatar.id == id
            if avatar.available?
              avatar.set
            end
          end
        end

        if active_dance.keep_new_avatar
          state.previous_avatar_id = id
        end
      end

      # Start displaying delayed responses
      if active_dance.later_response
        async_show_responses active_dance.later_response,\
          active_dance.delay_between_responses, room
      end

    else # if there is already an active_dance

      if active_dance.wait_to_dance
        upvote_song(room)
      end

      if active_dance.subsequent_dance_command_response
        room.say active_dance.subsequent_dance_command_response
      end
    end
  end

  def upvote_song(room)
    begin
      room.current_song.vote
    rescue Turntabler::APIError
      room.say "(I couldn't upvote the song."
      room.say "Turntable may be capping my votes if I've been voting unsually quickly.)"
    end
  end

  # Shows dance.later_response asynchronously
  def async_show_responses(response, delay, room)
    Thread.new {
      sleep delay
      room.say response
    }
  end

  # help_message() - return a string
  # Returns a message that can be used with the `help` command to describe what the command does to users.
  def help_message()
    return 'I\'ll upvote the current song and say something terribly clever.'
  end
end
