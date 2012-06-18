Rails::Engine.mixin __FILE__
class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :flagged_questions

  def self.sb_combine_accounts(u1, u2)
    u2.questions.update_all(:user_id => u1.id)
    u2.answers.update_all(:user_id => u1.id)
  end

  # TODO: make this less painful...
  def invited_to_question?(q)
    inv_count = Invite.where(:invitee_id => self.id, :tracking_object_id => q.id).count > 0
    inv_count2 = self.email && Invite.where(:invitee_email => self.email, :tracking_object_id => q.id).count > 0
    fbs_count = FbShare.where(:invitee_id => self.id, :tracking_object_id => q.id).count > 0
    fbs_count2 = self.fb_user_id && FbShare.where(:invitee_id => self.fb_user_id, :tracking_object_id => q.id).count > 0
    inv_count || inv_count2 || fbs_count || fbs_count2
  end
end