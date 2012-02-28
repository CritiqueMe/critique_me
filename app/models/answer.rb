# == Schema Information
#
# Table name: answers
#
#  id                        :integer(4)      not null, primary key
#  user_id                   :integer(4)
#  question_id               :integer(4)
#  multiple_choice_option_id :integer(4)
#  true_false_answer         :boolean(1)
#  open_text_answer          :text
#  created_at                :datetime
#  updated_at                :datetime
#

class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  belongs_to :multiple_choice_option

  validates_uniqueness_of :user_id, :scope => :question_id

  after_create :notify_asker_of_answer

  attr_accessor :post_to_wall

  def notify_asker_of_answer
    a_cnt = Answer.where(:question_id => self.question_id).count
    EmailDelivery.user_mail(:answers_gathered, self.user, {:question_id => self.question_id}) if a_cnt == 5
  end
end
