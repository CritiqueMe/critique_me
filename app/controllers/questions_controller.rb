class QuestionsController < ApplicationController
  layout 'prototype'

  before_filter :enforce_login, :except => :question
  before_filter :get_fb_access_token, :except => :question

  def question
    @question = Question.find(params['id'])
    if @questionnaire = @question.default_question.try(:questionnaire)
      @questions = @question.user.questions.joins(:default_question).
          where('default_questions.questionnaire_id=?', @questionnaire.id).
          where('questions.created_at>=? AND questions.created_at<?', @question.created_at-30.seconds, @question.created_at+30.seconds)
    else
      @questions = [@question]
    end
    @answer = Answer.new(:question => @question, :user => @user, :post_to_wall => true)
    if params['fb_action_ids'] || params['cmfb']  # This is the result of an FB click
      if @user.nil?
        session[:referrer_id] = @question.user_id  # make sure the user gets a viral path
        session[:clicked_question_id] = @question.id
        tracker = ViralEntrance.create(
            :inviter_id => session[:referrer_id],
            :source => 'fb_question',
            :fb_source => params['fb_source'],
            :state => "entered"
        )
        session[:viral_entrance_id] = tracker.id
        session[:straight_outta_fb] = true
        redirect_to welcome_path and return
      end
    else

    end

    # prepare canned questions
    if @question.user != @user
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
    end

    render :layout => false
  end

  def new_question
    if params['question']
      @question = Question.new(params['question'])
      @question.user_id = @user.id
      @question.multiple_choice_options.delete_all unless @question.question_type == Question::QUESTION_TYPES.index(:multiple_choice)
      @question.save
      if @question.valid?
        post_question_to_open_graph(@question) if @question.post_to_wall == "1"
        #redirect_to share_path(@question)
        redirect_to question_path(@question)
      else
        #render :partial => "questions/form"
      end
    else
      @question = Question.new(:question_type => Question::QUESTION_TYPES.index(:multiple_choice), :post_to_wall => true)
      2.times do
        @question.multiple_choice_options.build
      end
      Rails.logger.info "***** #{@question.multiple_choice_options.length}"
    end
  end

  def edit_question
    @question = Question.find(params['id'])
    if params['question']
      @question.update_attributes params['question']
      @question.multiple_choice_options.delete_all unless @question.question_type == Question::QUESTION_TYPES.index(:multiple_choice)
      if @question.valid?
        # TODO: post changes to OpenGraph
        #redirect_to share_path(@question)
        redirect_to question_path(@question)
      else
        #render :partial => "questions/form"
      end
    end
  end

  def choose_question
    if request.post?
      @default_question = DefaultQuestion.find(params['id'])
      @question = Question.create_from_default_question(@default_question, @user)
      if @question.valid?
        post_question_to_open_graph(@question) # TODO: ask for permission to do this
        redirect_to share_path(@question)
      end
    else
      @default_questions = DefaultQuestion.active.not_in_questionnaire
      @questionnaires = Questionnaire.active
    end
  end

  def questionnaire
    @questionnaire = Questionnaire.find(params['id'])
    if request.post?
      qids = params['default_question_ids'].split(",")
      render :text => "No questions selected" and return if qids.empty?
      questions = []
      qids.each do |qid|
        if dq = DefaultQuestion.find_by_id(qid)
          q = Question.create_from_default_question(dq, @user)
          post_question_to_open_graph(q) # TODO: ask for permission to do this
          questions << q
        end
      end
      redirect_to share_path(questions.first)
    end
  end

  def post_to_graph
    @question = Question.find(params['id'])
    post_question_to_open_graph(@question)
    render :partial => "share/thanks", :locals => {:num_shared => 'all'}
  end


  private

  def post_question_to_open_graph(question)
    token = session[:fb_access_token]
    response = `curl -s -F 'question=#{question_url(question)}' -F 'access_token=#{token}' 'https://graph.facebook.com/me/#{SEED_BLOCKS_ENGINE_CONFIG[:fb_app_namespace]}:ask'`
    Rails.logger.info "posted question to open graph, response = #{response}"
    json = JSON.parse(response)
    question.update_attribute :fb_question_id, json["id"]
  end

end