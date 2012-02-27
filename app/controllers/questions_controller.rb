class QuestionsController < ApplicationController
  layout 'prototype'

  before_filter :enforce_login, :except => :question
  before_filter :get_fb_access_token, :except => :question

  def question
    @question = Question.find(params['id'])
    if @questionnaire = @question.default_question.try(:questionnaire)
      @questions = @question.user.questions.joins(:default_question).where('default_questions.questionnaire_id=?', @questionnaire.id)
    else
      @questions = [@question]
    end
    @answer = Answer.new(:question => @question, :user => @user)
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
        redirect_to welcome_path and return
      end
    else

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
      3.times do
        @question.multiple_choice_options.build
      end
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

      # remove previously asked questions/questionnaires
      asked_qs = @user.questions.where('default_question_id IS NOT NULL').all
      @default_questions.reject!{|dq| asked_qs.any?{|q| q.default_question_id == dq.id}}
      @questionnaires.reject!{|qn| asked_qs.any?{|q| q.default_question_id == qn.default_questions.first.id}}
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
    Rails.logger.info "posted to open graph, response = #{response}"
    json = JSON.parse(response)
    question.update_attribute :fb_question_id, json["id"]
  end


end