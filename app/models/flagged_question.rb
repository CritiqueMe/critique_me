class FlaggedQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  scope :visible, where(:hidden => false)
end