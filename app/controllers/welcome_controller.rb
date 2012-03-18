Rails::Engine.mixin __FILE__
class WelcomeController < ApplicationController

  def path_answer
    @answer = Answer.new(params['answer'])
    @answer.save
    post_answer_to_open_graph(@answer) if @answer.post_to_wall == "1"
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


  private

  def post_answer_to_open_graph(answer)
    token = session[:fb_access_token]
    response = `curl -s -F 'question=#{question_url(answer.question)}' -F 'access_token=#{token}' 'https://graph.facebook.com/me/#{SEED_BLOCKS_ENGINE_CONFIG[:fb_app_namespace]}:answer'`
    Rails.logger.info "posted answer to open graph, response = #{response}"
    json = JSON.parse(response)
    answer.update_attribute :fb_answer_id, json["id"]
  end
end