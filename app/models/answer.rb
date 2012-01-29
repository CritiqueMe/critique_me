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
end
