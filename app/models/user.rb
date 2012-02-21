Rails::Engine.mixin __FILE__
class User < ActiveRecord::Base
  has_many :questions
  has_many :answers

  def self.sb_combine_accounts(u1, u2)
    u2.questions.update_all(:user_id => u1.id)
    u2.answers.update_all(:user_id => u1.id)
  end
end