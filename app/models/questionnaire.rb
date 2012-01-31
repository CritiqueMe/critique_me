# == Schema Information
#
# Table name: questionnaires
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

class Questionnaire < ActiveRecord::Base
  has_many :default_questions

  scope :active, where(:active => true)
end
