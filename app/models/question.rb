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
  belongs_to :default_question

  has_many :multiple_choice_options, :dependent => :destroy
  accepts_nested_attributes_for :multiple_choice_options
  has_many :answers

  mount_uploader :photo, QuestionPhotoUploader

  QUESTION_TYPES = [:multiple_choice, :true_false, :open_text]

  validates :user_id, :presence => true
  validates_presence_of :category_id, :question_text, :question_type, :message => "Required"
  validates_uniqueness_of :default_question_id, :scope => :user_id  # prevent users from reposting default questions

  attr_accessor :post_to_wall

  def self.create_from_default_question(dq, user)
    q = Question.create({
        :user_id => user.id,
        :question_type => dq.question_type,
        :question_text => dq.question_text,
        :category_id => dq.category_id,
        :default_question_id => dq.id
    })
    dq.default_multiple_choice_options.each do |o|
      MultipleChoiceOption.create({
          :question_id => q.id,
          :answer_text => o.answer_text,
          :default_multiple_choice_option_id => o.id
      })
    end if q.question_type == QUESTION_TYPES.index(:multiple_choice)
    q
  end
end
