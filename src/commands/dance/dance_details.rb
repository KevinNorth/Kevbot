require_relative

class DanceDetails
  attr_reader :response
  attr_reader :later_responses, :delay_between_responses
  attr_reader :wait_to_dance
  attr_reader :subsequent_dance_commands
  attr_reader :change_avatar, :keep_new_avatar, :avatar_options

  def initialize(response, later_responses, delay_between_responses, wait_to_dance, subsequent_dance_commands, change_avatar, keep_new_avatar, avatar_options)
    @response = response
    @later_responses = later_responses
    @delay_between_responses = delay_between_responses
    @wait_to_dance = wait_to_dance
    @subsequent_dance_commands = subsequent_dance_commands
    @change_avatar = change_avatar
    @keep_new_avatar = keep_new_avatar
    @avatar_options = avatar_options
  end
end
