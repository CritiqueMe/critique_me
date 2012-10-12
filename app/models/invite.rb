Rails::Engine.mixin __FILE__
class Invite
  def self.should_limit_num_invites_received?
    false
  end

  def self.allow_sending_to_existing_users?
    true
  end

  def self.allow_resends_in_previous_fortnight?
    true
  end
end