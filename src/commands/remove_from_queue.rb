require_relative '../kevbot_state.rb'
require_relative 'command.rb'

class RemoveFromQueueCommand
include Command

  # Returns an array of strings that can be used as command names in the chat.
  def names()
    names = []
    names.push "q-"
    return names
  end

  # execute(string) - return nothing
  # Removes the user issuing the command to the queue
  def execute(parameter, user, client, state)
    room = client.room
    queue = state.room_queue

    if queue.is_user_in_queue? user
      if queue.remove_user user
        room.say "@#{user.name}, I removed you from the queue."
      else
        room.say "@#{user.name}, I couldn't remove you from the queue."
      end
    else
      room.say "@#{user.name}, you weren't in the queue, so I didn't change anything."
    end
  end

  # help_message() - return a string
  # Returns a message that can be used with the `help` command to describe what the command does to users.
  def help_message()
    return 'I\'ll remove you from the line to get on deck. (I\'ll automatically remove you if you leave the room.)'
  end
end
