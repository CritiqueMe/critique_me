class FlaggedQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  scope :visible, where(:hidden => false)

  after_create :ping_admins

  def ping_admins
    AdminMailer.question_flagged(self).deliver
  end
end