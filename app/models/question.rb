# == Schema Information
#
# Table name: questions
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  question_type       :integer(4)
#  default_question_id :integer(4)
#  category_id         :integer(4)
#  question_text       :text
#  photo               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class Question < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :category
  belongs_to :user

  has_many :multiple_choice_options, :dependent => :destroy
  accepts_nested_attributes_for :multiple_choice_options
  has_many :answers

  mount_uploader :photo, QuestionPhotoUploader

  QUESTION_TYPES = [:multiple_choice, :true_false, :open_text]

  validates_presence_of :category_id, :question_text, :question_type, :message => "Required"
end
