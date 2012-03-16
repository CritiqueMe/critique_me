class CannedQuestion < ActiveRecord::Base
  has_many :questions
  belongs_to :category

  scope :active, where(:active => true)
end