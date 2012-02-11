Rails::Engine.mixin __FILE__
class User < ActiveRecord::Base
  has_many :questions
  has_many :answers
end