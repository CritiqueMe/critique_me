Rails::Engine.mixin __FILE__
class Admin::UsersController < Admin::SbAdminController
  def show
    @user = User.where(:id => params['id']).first
    @questions = @user.questions
    @answers = @user.answers
  end
end