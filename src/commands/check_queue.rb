require_relative '../kevbot_state.rb'
require_relative 'command.rb'

class CheckQueue
include Command

  # Returns an array of strings that can be used as command names in the chat.
  def names()
    names = []
    names.push "q?"
    names.push "queue"
    return names
  end

  # execute(string) - return nothing
  # Removes the user issuing the command to the queue
  def execute(parameter, user, client, state)
    room = client.room
    queue = state.room_queue

    if queue.empty?
      room.say "The queue is empty."
      if room.djs.size < room.dj_capacity
        room.say "Feel free to get on deck!"
      end
    else
      room.say "The queue is:"
      for user in queue.check
        room.say user.name
      end
    end
  end

  # help_message() - return a string
  # Returns a message that can be used with the `help` command to describe what the command does to users.
  def help_message()
    return 'I\'ll let you know who\'s in line to get on deck.'
  end
end
