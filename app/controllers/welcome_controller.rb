Rails::Engine.mixin __FILE__
class WelcomeController < ApplicationController

  def path_answer
    @answer = Answer.new(params['answer'])
    @answer.save
    post_answer_to_open_graph(@answer) if @answer.post_to_wall == "1"
    session[:clicked_question_id] = nil
    increment_page
    redirect_to welcome_path
  end

  def canned_finished
    increment_page
    redirect_to welcome_path
  end

  def sb_prepare_page_type_variables
    if %w(answer canned_questions).include?(@path_page.page_type)
      if session[:clicked_question_id]
        @question = Question.where(:id => session[:clicked_question_id]).first
        if @questionnaire = @question.default_question.try(:questionnaire)
          @questions = @question.user.questions.joins(:default_question).where('default_questions.questionnaire_id=?', @questionnaire.id)
        else
          @questions = [@question]
        end
        @answer = Answer.new(:question_id => @question.id, :user_id => @user.id, :post_to_wall => true)

        # populate a session var so we can show them what their friend answered, later
        if @question.canned_question_id
          session[:show_canned_answer] = @question.id
        end
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
      @flagged_question = FlaggedQuestion.new(:question_id => @question.id, :user_id => @user.id)

      # prepare canned questions
      @canned_questions = CannedQuestion.active.limit(5).order("RAND()")
      get_fb_friends
      if @fb_friends && @fb_friends.length >= 3
        @canned_choices = @canned_questions.map do |cq|
          this_q_choice = []
          @fb_friends.shuffle!
          cq.num_choices.times do |i|
            friend = @fb_friends[i]
            this_q_choice << {
                :name => friend['name'],
                :id => friend['id']
            }
          end
          this_q_choice
        end
      else
        # no fb friends, so let's not do the canned question thing
        @canned_questions = nil
      end

    elsif @path_page.page_type == "register"
      @last_questions = DefaultQuestion.active.featured.order('last_asked_at DESC')
    end
  end


  private

  def post_answer_to_open_graph(answer)
    token = session[:fb_access_token]
    response = `curl -s -F 'question=#{question_url(answer.question)}' -F 'access_token=#{token}' 'https://graph.facebook.com/me/#{Facebook::CONFIG[:namespace]}:answer'`
    Rails.logger.info "posted answer to open graph, response = #{response}"
    json = JSON.parse(response)
    answer.update_attribute :fb_answer_id, json["id"]
  end

  def default_experiment_delivery_url
    if session[:clicked_question_id]
      question_path session[:clicked_question_id]
    else
      new_question_path
    end
  end
end