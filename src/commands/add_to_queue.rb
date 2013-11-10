require_relative '../kevbot_state.rb'
require_relative 'command.rb'

class AddToQueue
include Command

  # Returns an array of strings that can be used as command names in the chat.
  def names()
    names = []
    names.push "q+"
    return names
  end

  # execute(string) - return nothing
  # Adds the user issuing the command to the queue
  def execute(parameter, user, client, state)
    room = client.room
    queue = state.room_queue

    if queue.push_user user
      room.say "@#{user.name}, I added you to the queue."
    else
      if queue.is_user_in_queue? user
        room.say "You're already in the queue, @#{user.name}!"
      elsif queue.full?
        room.say "The queue completely full, @#{user.name}."
      else
        room.say "I couldn't add you to the queue, @#{user.name}"
      end
    end
  end

  # help_message() - return a string
  # Returns a message that can be used with the `help` command to describe what the command does to users.
  def help_message()
    return 'I\'ll add you to the line to get on deck.'
  end
end
