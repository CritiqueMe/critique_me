# == Schema Information
#
# Table name: default_questions
#
#  id               :integer(4)      not null, primary key
#  category_id      :integer(4)
#  questionnaire_id :integer(4)
#  question_type    :integer(4)      default(0)
#  question_text    :text
#  active           :boolean         default(true)
#

class DefaultQuestion < ActiveRecord::Base
  belongs_to :category
  belongs_to :questionnaire
  has_many :default_multiple_choice_options
  accepts_nested_attributes_for :default_multiple_choice_options

  validates_presence_of :category_id, :question_text, :question_type, :message => "Required"

  scope :active, where(:active => true)
  scope :not_in_questionnaire, where(:questionnaire_id => nil)
  scope :prioritized, order('priority DESC')
  scope :featured, where(:featured => true)
  scope :random, order('RAND()')

  private

end
