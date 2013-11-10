class DanceDetails
  @@all_dances = nil

  def self.GetAllDances()
    # Lazy-load the dances the first time they're accessed
    unless @@all_dances
      @@all_dances = []

      dance_config = YAML.load_file('dances.yaml')
      for config in dance_config["dances"]
        response = config["response"]

        later_responses = config["later_responses"]
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

        dance = DanceDetails.new(response, later_responses,\
         delay_between_responses, wait_to_dance, subsequent_dance_command_response,\
         change_avatar, keep_new_avatar, avatar_options)
        @@all_dances.push dance
      end
    end

    return @@all_dances
  end

  attr_reader :response
  attr_reader :later_responses, :delay_between_responses
  attr_reader :wait_to_dance
  attr_reader :subsequent_dance_command_response
  attr_reader :change_avatar, :keep_new_avatar, :avatar_options

  def initialize(response, later_responses, delay_between_responses,\
    wait_to_dance, subsequent_dance_command_response, change_avatar,\
    keep_new_avatar, avatar_options)
    @response = response
    @later_responses = later_responses
    @delay_between_responses = delay_between_responses
    @wait_to_dance = wait_to_dance
    @subsequent_dance_command_response = subsequent_dance_command_response
    @change_avatar = change_avatar
    @keep_new_avatar = keep_new_avatar
    @avatar_options = avatar_options
  end
end
