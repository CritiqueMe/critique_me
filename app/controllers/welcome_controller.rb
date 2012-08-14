Rails::Engine.mixin __FILE__
class WelcomeController < ApplicationController

  def path_answer
    @answer = Answer.new(params['answer'])
    @answer.save
    post_answer_to_open_graph(@answer) if @answer.post_to_wall == "1"
    #session[:clicked_question_id] = nil
    increment_page
    redirect_to welcome_path
  end

  def canned_finished
    increment_page
    redirect_to welcome_path
  end

  def choose_question
    if @user && @user.id
      @default_question = DefaultQuestion.find(params['default_question_id'])
      if @user.questions.where(:default_question_id => @default_question.id).count == 0
        @question = Question.create_from_default_question(@default_question, @user)
        if @question.valid?
          @default_question.update_attribute :last_asked_at, Time.now
          post_question_to_open_graph(@question) # TODO: ask for permission to do this
        end
      end
    else
      session[:path_chosen_question_id] = params['default_question_id']
    end
    @tracker.log(:question_chosen, "User chose a question to ask")
    @tracker.converted = true if @experiment.conversion_event == "question_chosen"
    save_path_tracker
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

    elsif @path_page.page_type == "register" || @path_page.page_type == "splash"
      @last_questions = DefaultQuestion.active.featured.order('last_asked_at DESC')
    elsif @path_page.page_type == "choose_question" || @path_page.page_type == "choose_q_about_cm_dlg"
      @per_page = 7
      scope = DefaultQuestion.active.not_in_questionnaire.prioritized
      scope = scope.where(:category_id => params['category_id']) if params['category_id'] && params['category_id'] != ''
      @num_questions = scope.count
      @default_questions = scope.paginate(:page => params['page'], :per_page => @per_page)
    elsif @path_page.page_type == "share"
      @question = @user.questions.last
    end
  end

  private

  def post_answer_to_open_graph(answer)
    token = session[:fb_access_token]
    response = `curl -s -F 'question=#{question_url(answer.question)}' -F 'access_token=#{token}' 'https://graph.facebook.com/me/#{Facebook::CONFIG["namespace"]}:answer'`
    Rails.logger.info "posted answer to open graph, response = #{response}"
    json = JSON.parse(response)
    answer.update_attribute :fb_answer_id, json["id"]
  end

  def sb_after_register
    if session[:path_chosen_question_id]   # this is set in welcome#choose_question
      @default_question = DefaultQuestion.find(session[:path_chosen_question_id])
      if @user.questions.where(:default_question_id => @default_question.id).count == 0
        @question = Question.create_from_default_question(@default_question, @user)
        if @question.valid?
          @default_question.update_attribute :last_asked_at, Time.now
          post_question_to_open_graph(@question) # TODO: ask for permission to do this
        end
      end
      session[:path_chosen_question_id] = nil
      flash[:show_share] = true
    end
  end

  def default_experiment_delivery_url
    if @user.questions.count > 0
      question_path @user.questions.last
    else
      choose_question_path
    end
  end

  def already_signed_in_redirect
    session[:clicked_question_id] ? question_path(session[:clicked_question_id]) : choose_question_path
  end
end