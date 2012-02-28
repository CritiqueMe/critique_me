class AnswersController < ApplicationController


  def new
    if request.post?
      @answer = Answer.new(params['answer'])
      @answer.save
      flash[:notice] = "Answer Posted"

      post_answer_to_open_graph(@answer) if @answer.post_to_wall == "1"

      # If this question is part of a questionnaire and the user hasn't answered all of the questions yet, redirect
      # back to the question page.  Otherwise, send them to the build question page
      if questionnaire = @answer.question.default_question.try(:questionnaire)
        qs = @answer.question.user.questions.joins(:default_question).where('default_questions.questionnaire_id=?', questionnaire.id)
        if @user.answers.where(:question_id => qs.map(&:id)).count == qs.length
          redirect_to new_question_path
        else
          redirect_to question_path(@answer.question)
        end
      else
        redirect_to new_question_path
      end
    else
      redirect_to dashboard_path
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