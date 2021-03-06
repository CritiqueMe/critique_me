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
  has_many :canned_question_choices
  has_many :answers

  mount_uploader :photo, QuestionPhotoUploader

  QUESTION_TYPES = [:multiple_choice, :true_false, :open_text, :canned_question]

  validates :user_id, :presence => true, :unless => Proc.new{|x| x.question_type == QUESTION_TYPES.index(:canned_question)}
  validates_presence_of :question_text, :question_type, :message => "Required"
  validates_length_of :question_text, :maximum => 200

  attr_accessor :post_to_wall

  def self.build_from_default_question(dq, user)
    Question.new({
        :user_id => user.id,
        :question_type => dq.question_type,
        :question_text => dq.question_text,
        :category_id => dq.category_id,
        :default_question_id => dq.id,
        :public => true
    })
  end

  def self.create_from_default_question(dq, user)
    q = build_from_default_question(dq, user)
    q.save
    dq.default_multiple_choice_options.each do |o|
      MultipleChoiceOption.create({
          :question_id => q.id,
          :answer_text => o.answer_text,
          :default_multiple_choice_option_id => o.id
      })
    end if q.question_type == QUESTION_TYPES.index(:multiple_choice)
    q
  end

  def self.create_from_canned_question(cq, user, choices)
    q = Question.create({
        :user_id => user.id,
        :question_type => QUESTION_TYPES.index(:canned_question),
        :question_text => cq.text,
        :category_id => cq.category_id,
        :canned_question_id => cq.id
    })
    choices.each do |choice|
      CannedQuestionChoice.create({
        :question_id => q.id,
        :friend_name => choice[:name],
        :friend_fb_id => choice[:id]
      })
    end if q.id
    q
  end

  def question_text_pretty
    rtn = self.question_text
    if canned_question_id
      rtn += "  " + canned_question_choices_pretty + "?"
    end
    rtn
  end

  def canned_question_choices_pretty
    choices = self.canned_question_choices
    rtn = ""
    choices.each_with_index do |c,i|
      if i > 0
        if i+1 == choices.length
          rtn += " or "
        else
          rtn += ", "
        end
      end
      rtn += c.friend_name
    end
    rtn
  end

  # returns if the question has been shared with the minimum number of friends yet.  If a question has been posted to
  # a user's timeline, that means all of his friends have seen it, so we return true.  Otherwise, count the total number
  # of invites and fb_shares sent for this question
  def shared_with_minimum?
    if fb_question_id
      true
    else
      num_invited >= 3
    end
  end

  def num_invited
    num_invites = Invite.where(:tracking_object_id => self.id).count
    num_fb_shares = FbShare.where(:tracking_object_id => self.id).count
    num_invites + num_fb_shares
  end

  # we only allow users to share once per day
  def already_shared_today?
    FbShare.where(:tracking_object_id => self.id, :created_at.gte => Time.midnight).count > 0
  end

  def answer_dialog_title
    if self.canned_question_id
      user.first_last_initial + " was asked..."
    elsif public?
      user.first_last_initial + " asked..."
    else
      "#{user.first_last_initial} asked you #{"and #{self.num_invited-1} other #{self.num_invited-1 == 1 ? "person" : "people"} " if self.num_invited>1}a private question.  All responses on CritiqueMe are <b>totally anonymous</b>.  We NEVER reveal the identity of the answerer."
    end
  end

  def self.send_invite_reminders
    Question.joins("LEFT JOIN answers ON questions.id = answers.question_id").
        where(:canned_question_id => nil).
        where('questions.created_at>=? AND questions.created_at<?', Time.now-8.days, Time.now-7.days).
        select('questions.*, COUNT(answers.question_id) AS num_answers').
        having('num_answers < 3').
        group('questions.id').find_each do |q|

      EmailDelivery.user_mail(:question_invite_reminder, q.user, {:question_id => q.id})
    end
  end
end
