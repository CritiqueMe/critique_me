# == Schema Information
#
# Table name: default_multiple_choice_options
#
#  id                  :integer(4)      not null, primary key
#  default_question_id :integer(4)
#  answer_text         :text
#

class DefaultMultipleChoiceOption < ActiveRecord::Base
  belongs_to :default_question
  validates_presence_of :answer_text, :message => "Required", :allow_blank => false
end
