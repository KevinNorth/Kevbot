class KevbotState
  attr_accessor :active_dance
  attr_accessor :previous_avatar_id

  def initialize(client)
    @active_dance = nil
    @previous_avatar_id = client.user.avatar.id
  end
end
