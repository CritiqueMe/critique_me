Rails::Engine.mixin __FILE__
class WelcomeController < ApplicationController

  def path_answer
    @answer = Answer.new(params['answer'])
    @answer.save
    increment_page
    redirect_to welcome_path
  end

  def sb_prepare_page_type_variables
    if @path_page.page_type == "answer" && session[:clicked_question_id]
      @question = Question.where(:id => session[:clicked_question_id]).first
      @answer = Answer.new(:question => @question, :user => @user)
    end
  end
end