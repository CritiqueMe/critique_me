Rails::Engine.mixin __FILE__
class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
  has_many :flagged_questions

  EMAIL_PREFERENCES = [:no_restrictions, :once_per_week, :no_third_party, :no_email]

  validates :first_name, :exclusion => { :in => ["First Name"], :message => "First Name is required" }
  validates :last_name, :exclusion => { :in => ["Last Name"], :message => "Last Name is required" }

  def self.sb_combine_accounts(u1, u2)
    u2.questions.update_all(:user_id => u1.id)
    u2.answers.update_all(:user_id => u1.id)
  end

  def allowed_to_view_question?(q)
    q.public? || q.user == self || canned_invitee?(q) || invited_to_question?(q) || fb_shared?(q)
  end

  def canned_invitee?(q)
    q.canned_question_choices.any?{|cqc| cqc.friend_fb_id == self.fb_user_id}
  end

  def invited_to_question?(q)
    Invite.where(:invitee_id => self.id, :tracking_object_id => q.id).count > 0 ||
      (self.email && Invite.where(:invitee_email => self.email, :tracking_object_id => q.id).count > 0)
  end

  def fb_shared?(q)
    FbShare.where(:invitee_id => self.id, :tracking_object_id => q.id).count > 0 ||
      (self.fb_user_id && FbShare.where(:invitee_fb_user_id => self.fb_user_id, :tracking_object_id => q.id).count > 0)
  end

  # Run daily via a cron job
  def self.send_login_reminders
    User.where('last_login >= ? AND last_login < ?', Time.now-15.days, Time.now-14.days).find_each do |u|
      EmailDelivery.user_mail(:login_reminder, u)
    end
  end

  def self.send_weekly_email
    # TODO: make this a bulk mailing?
    User.where('email IS NOT NULL AND email != "" AND email_preferences != ?', EMAIL_PREFERENCES.index(:no_email)).find_each do |u|
      EmailDelivery.user_mail(:weekly_email, u)
    end
  end

  def show_pitch_dlg?
    (!referrer_id.nil? || !affiliate_link_id.nil?) && !pitch_dlg_acknowledged?
  end
end