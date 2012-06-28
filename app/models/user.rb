Rails::Engine.mixin __FILE__
class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :flagged_questions

  EMAIL_PREFERENCES = [:no_restrictions, :once_per_week, :no_third_party, :no_email]

  def self.sb_combine_accounts(u1, u2)
    u2.questions.update_all(:user_id => u1.id)
    u2.answers.update_all(:user_id => u1.id)
  end

  # TODO: make this less painful...
  def invited_to_question?(q)
    canned_invitee = q.canned_question_choices.any?{|cqc| cqc.friend_fb_id == self.fb_user_id}
    inv_count = Invite.where(:invitee_id => self.id, :tracking_object_id => q.id).count > 0
    inv_count2 = self.email && Invite.where(:invitee_email => self.email, :tracking_object_id => q.id).count > 0
    fbs_count = FbShare.where(:invitee_id => self.id, :tracking_object_id => q.id).count > 0
    fbs_count2 = self.fb_user_id && FbShare.where(:invitee_fb_user_id => self.fb_user_id, :tracking_object_id => q.id).count > 0
    canned_invitee || inv_count || inv_count2 || fbs_count || fbs_count2
  end

  # Run daily via a cron job
  def self.send_login_reminders
    User.where('last_login >= ? AND last_login < ?', Time.now-15.days, Time.now-14.days).find_each do |u|
      EmailDelivery.user_mail(:login_reminder, u)
    end
  end

  def self.send_weekly_email
    # TODO: make this a bulk mailing?
    User.where('email_preferences != ?', EMAIL_PREFERENCES.index(:no_email)).find_each do |u|
      EmailDelivery.user_mail(:weekly_email, u)
    end
  end

  def show_pitch_dlg?
    !referrer_id.nil? && !pitch_dlg_acknowledged?
  end
end