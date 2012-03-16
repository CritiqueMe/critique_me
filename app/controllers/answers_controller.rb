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

  def canned_answer
    if request.post?
      @canned_question = CannedQuestion.find(params['id'])
      friend_ids = params['friend_ids'].split(",")
      friend_names = params['friend_names'].split(",")
      choices = []
      friend_ids.each_with_index do |id, i|
        choices << {:name => friend_names[i], :id => id}
      end
      q = Question.create_from_canned_question(@canned_question, @user, choices)
      cqc = CannedQuestionChoice.where(:question_id => q.id, :friend_fb_id => params['chosen_friend']).first
      a = Answer.create({
          :user_id => @user.id,
          :question_id => q.id,
          :canned_question_choice_id => cqc.id
      })
      if params['post_to_timeline'] == '1'
        post_answer_to_open_graph(a)
      end
      render :text => "success"
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