# A POCO that describes the behavior of the bot after a /dance command is issued
# The behavior of a robot dance is in the /commands/dance.rb DanceCommand
# class. That class uses this POCO to inform its behavior.
class Dance
  @@all_dances = nil

  # Load all of the dance configurations from dances.yaml, then
  # return them in an array
  def self.GetAllDances()
    # Lazy-load the dances the first time they're accessed
    unless @@all_dances
      @@all_dances = []

      dance_config = YAML.load_file('dances.yaml')
      for config in dance_config["dances"]
        response = config["response"]

        later_response = config["later_response"]
        delay_between_responses = config["delay_between_responses"]

        wait_to_dance = config["wait_to_dance"] ? \
          config["wait_to_dance"].to_s == "true" : false

        subsequent_dance_command_response = config["subsequent_dance_commands"]

        change_avatar = config["avatar"] ? true : false
        if change_avatar
          keep_new_avatar = config["avatar"]["keep"]
          avatar_options = config["avatar"]["options"]
        else
          keep_new_avatar = false
          avatar_options = []
        end

        dance = Dance.new(response, later_response,\
         delay_between_responses, wait_to_dance, subsequent_dance_command_response,\
         change_avatar, keep_new_avatar, avatar_options)
        @@all_dances.push dance
      end
    end

    return @@all_dances
  end

  # This is what the robot says immediately after recieving the
  # chat command. (mandatory)
  attr_reader :response

  # This is what the robot says if it says anything after the first
  # response. (optional, mandatory with delay_between_responses)
  attr_reader :later_response

  # This is the delay between messages after the first response.
  # (optional, mandatory with delay_between_responses)
  attr_reader :delay_between_responses

  # If set to "true", the robot won't dance the first time the /dance
  # command is issued. It will wait until the second time. (optional)
  attr_reader :wait_to_dance

  # The message the robot will say when it recieves a second /dance
  # command. (optional, mandatory with wait_to_dance)
  attr_reader :subsequent_dance_command_response

  # If the "avatar" hash is present for a dance, this will automatically
  # be set to true to tell the robot to change its avatar.
  attr_reader :change_avatar

  # If set to "true", the robot will keep its new avatar even after the
  # song is finished. Otherwise, it changes back after the song ends.
  # (optional, mandatory with avatar_options)
  attr_reader :keep_new_avatar

  # An array of avatar ids that the robot might switch to. If there is
  # only one element, the robot will always switch to that avatar. If
  # there is more than one element, the robot will pick one at random.
  # (optional, mandatory with keep_new_avatar)
  attr_reader :avatar_options

  def initialize(response, later_response, delay_between_responses,\
    wait_to_dance, subsequent_dance_command_response, change_avatar,\
    keep_new_avatar, avatar_options)
    @response = response
    @later_response = later_response
    @delay_between_responses = delay_between_responses
    @wait_to_dance = wait_to_dance
    @subsequent_dance_command_response = subsequent_dance_command_response
    @change_avatar = change_avatar
    @keep_new_avatar = keep_new_avatar
    @avatar_options = avatar_options
  end
end
