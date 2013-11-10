# Keeps track of a queue of users to get in line to DJ.
class RoomQueue
  attr_reader :queue
  attr_reader :max_length

  def initialize
    @queue = []
    @max_length = 10
  end

  def empty?
    return @queue.empty?
  end

  def full?
    return @queue.size >= max_length
  end

  def check
    return @queue
  end

  def is_user_in_queue?(user)
    return @queue.include? user
  end

  def push_user(user)
    if (full?) || (is_user_in_queue? user)
      return false
    else
      @queue.push user
      return true
    end
  end

  def pull_user
    return @queue.shift
  end

  def remove_user(user)
    if is_user_in_queue? user
      @queue.delete user
      return true
    else
      return false
    end
  end

  def can_user_dj?(user)
    if @queue.empty?
      return true
    else
      return @queue[0] == user
    end
  end

  def peek
    if @queue.empty?
      return nil
    else
      return @queue[0]
    end
  end

  def clear
    @queue = []
  end
end
