Rails::Engine.mixin __FILE__
class WelcomeController < ApplicationController

  def path_answer
    @answer = Answer.new(params['answer'])
    @answer.save
    increment_page
    redirect_to welcome_path
  end

  def sb_prepare_page_type_variables
    if @path_page.page_type == "answer"
      if session[:clicked_question_id]
        @question = Question.where(:id => session[:clicked_question_id]).first
        if @questionnaire = @question.default_question.try(:questionnaire)
          @questions = @question.user.questions.joins(:default_question).where('default_questions.questionnaire_id=?', @questionnaire.id)
        else
          @questions = [@question]
        end
        @answer = Answer.new(:question_id => @question.id, :user_id => @user.id, :post_to_wall => true)
      elsif @referrer
        if @referrer.questions.count > 0
          @question = @referrer.questions.last
          if @questionnaire = @question.default_question.try(:questionnaire)
            @questions = @question.user.questions.joins(:default_question).where('default_questions.questionnaire_id=?', @questionnaire.id)
          else
            @questions = [@question]
          end
          @answer = Answer.new(:question_id => @question.id, :user_id => @user.id, :post_to_wall => true)
        else
          # show canned question?  just move them along in the path for now
          increment_page
          redirect_to welcome_path
        end
      end
    end
  end
end