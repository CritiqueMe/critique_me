# == Schema Information
#
# Table name: multiple_choice_options
#
#  id                                  :integer(4)      not null, primary key
#  question_id                         :integer(4)
#  default_multiple_choice_question_id :integer(4)
#  answer_text                         :text
#  created_at                          :datetime
#  updated_at                          :datetime
#

class MultipleChoiceOption < ActiveRecord::Base
  belongs_to :question
  has_many :answers

  validates_presence_of :answer_text, :message => "Required", :allow_blank => false
end
