# == Schema Information
#
# Table name: categories
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

class Category < ActiveRecord::Base
  has_many :questions
  has_many :default_questions

  scope :active, where(:active => true)
  scope :for_select, active.order("name")
end
