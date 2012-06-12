class CannedQuestion < ActiveRecord::Base
  has_many :questions
  belongs_to :category

  scope :active, where(:active => true)

  validates :category_id, :presence => true
  #validates :question_id, :presence => true
end