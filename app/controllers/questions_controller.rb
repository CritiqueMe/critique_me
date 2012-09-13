class QuestionsController < ApplicationController
  layout 'cm2'

  before_filter :enforce_login, :except => :question
  before_filter :get_fb_access_token, :except => [:question, :toggle_pitch_dlg]
  skip_before_filter :verify_authenticity_token, :only => :choose_question

  def question
    @question = Question.find(params['id'])

    redirect_to dashboard_path and return unless @question.active?

    @answer = Answer.new(:question => @question, :user => @user, :post_to_wall => true)
    if params['fb_action_ids'] || params['cmfb']  # This is the result of an FB click

      # populate a session var so we can show them what their friend answered, later
      # UPDATE - turning off canned question functionality - jtg 9/13/12
      #if @question.canned_question_id
      #  session[:show_canned_answer] = @question.id
      #end
      session[:show_pitch_dlg] = true

      if @user.nil?
        session[:referrer_id] = @question.user_id  # make sure the user gets a viral path
        session[:clicked_question_id] = @question.id
        if params['cmfb']
          session[:fb_share_tracking_object_id] = @question.id
          session[:fb_share_cmfb] = params['cmfb']   # cmfb is a timestamp that helps us find the original FB Share event
        else
          tracker = ViralEntrance.create(
              :inviter_id => session[:referrer_id],
              :source => 'fb_question',
              :fb_source => params['fb_source'],
              :state => "entered"
          )
          session[:viral_entrance_id] = tracker.id
        end

        redirect_to welcome_path and return
      end
    else
      @fb_share_template = FbShareTemplate.active.
          where(:share_type => "open_graph", :question_type => (@question.canned_question_id ? "canned" : (@question.public? ? "public" : "private"))).
          random.first
    end

    # prepare canned questions
    # UPDATE - turning off canned question functionality - jtg 9/13/12
    @canned_questions = nil
    #if @user
    #  @canned_questions = CannedQuestion.active.limit(5).order("RAND()")
    #  get_fb_friends
    #  if @fb_friends && @fb_friends.length >= 3
    #    @canned_choices = @canned_questions.map do |cq|
    #      this_q_choice = []
    #      @fb_friends.shuffle!
    #      cq.num_choices.times do |i|
    #        friend = @fb_friends[i]
    #        this_q_choice << {
    #            :name => friend['name'],
    #            :id => friend['id']
    #        }
    #      end
    #      this_q_choice
    #    end
    #  else
    #    # no fb friends, so let's not do the canned question thing
    #    @canned_questions = nil
    #  end
    #end

    # build flagged_question object
    @flagged_question = FlaggedQuestion.new(:question_id => @question.id, :user_id => @user.id) if @user

  end

  def new_question
    @default_question_text = "Ex: Am I a talented singer?"
    @default_mc_answer_text = "Enter answer choice"
    @last_five_questions = DefaultQuestion.active.featured.order('last_asked_at DESC')
    @fb_share_template = FbShareTemplate.active.random.first

    if session[:show_pitch_dlg] && @user.show_pitch_dlg?
      @show_pitch_dlg = true
    else
      @show_pitch_dlg = false
    end
    session[:show_pitch_dlg] = false

    if params['question']

      params['question']['question_text'] = '' if params['question']['question_text'] == @default_question_text
      params['question']['multiple_choice_options_attributes'].each do |k,v|
        v['answer_text'] = '' if v['answer_text'] == @default_mc_answer_text
      end if params['question']['multiple_choice_options_attributes']

      @question = Question.new(params['question'])
      @question.user_id = @user.id
      @question.multiple_choice_options.delete_all unless @question.question_type == Question::QUESTION_TYPES.index(:multiple_choice)
      @question.save
      if @question.valid?
        post_question_to_open_graph(@question) if @question.public?
        @question.default_question.update_attribute :last_asked_at, Time.now if @question.default_question
        #redirect_to share_path(@question)
        flash[:show_share] = true
        redirect_to question_path(@question) and return
      end
    elsif params['default_question_id']
      dq = DefaultQuestion.find(params['default_question_id'])
      @question = Question.build_from_default_question(dq, @user)
      dq.default_multiple_choice_options.each do |mco|
        @question.multiple_choice_options.build({
            :question_id => @question.id,
            :answer_text => mco.answer_text,
            :default_multiple_choice_option_id => mco.id
        })
      end
    else
      @question = Question.new(:question_type => Question::QUESTION_TYPES.index(:true_false))
      2.times do
        @question.multiple_choice_options.build
      end

      if params['show_canned_answer'] == '1' && session[:show_canned_answer]
        if q = Question.find(session[:show_canned_answer])
          a = q.answers.first
          selected_answer = if a.canned_question_choice.friend_fb_id == @user.fb_user_id
            a.canned_question_choice.friend_name
          else
            "you"
          end
          @show_canned_answer = "#{q.user.first_name} selected #{selected_answer} as the answer to \"#{q.question_text}\""
        end
        session[:show_canned_answer] = nil
      end
    end
  end

  def edit_question
    @question = Question.find(params['id'])
    @default_question_text = "Ex: Am I a talented singer?"
    @default_mc_answer_text = "Enter answer choice"
    @last_five_questions = DefaultQuestion.active.featured.order('last_asked_at DESC')
    @fb_share_template = FbShareTemplate.active.random.first
    if params['question']
      @question.update_attributes params['question']
      @question.multiple_choice_options.delete_all unless @question.question_type == Question::QUESTION_TYPES.index(:multiple_choice)
      if @question.valid?
        # TODO: post changes to OpenGraph
        #redirect_to share_path(@question)
        flash[:show_share] = true
        redirect_to question_path(@question)
      else
        #render :partial => "questions/form"
      end
    end
  end

  def choose_question
    @per_page = 7

    if request.post?
      @default_question = DefaultQuestion.find(params['id'])
      @question = Question.create_from_default_question(@default_question, @user)
      if @question.valid?
        @default_question.update_attribute :last_asked_at, Time.now
        post_question_to_open_graph(@question) # TODO: ask for permission to do this
        redirect_to share_path(@question)
      end
    else
      scope = DefaultQuestion.active.not_in_questionnaire.prioritized
      scope = scope.where(:category_id => params['category_id']) if params['category_id'] && params['category_id'] != ''
      @num_questions = scope.count
      @default_questions = scope.paginate(:page => params['page'], :per_page => @per_page)

      if session[:show_pitch_dlg] && @user.show_pitch_dlg?
        @show_pitch_dlg = true
      else
        @show_pitch_dlg = false
      end
      session[:show_pitch_dlg] = false

      if params['show_canned_answer'] == '1' && session[:show_canned_answer]
        if q = Question.find(session[:show_canned_answer])
          a = q.answers.first
          selected_answer = if a.canned_question_choice.friend_fb_id == @user.fb_user_id
            a.canned_question_choice.friend_name
          else
            "you"
          end
          @show_canned_answer = "#{q.user.first_name} selected #{selected_answer} as the answer to \"#{q.question_text}\""
        end
        session[:show_canned_answer] = nil
      end
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

  def flag
    @flagged_question = FlaggedQuestion.new(params['flagged_question'])
    @flagged_question.save
    redirect_to question_path(@flagged_question.question)
  end

  def toggle_pitch_dlg
    @user.update_attribute :pitch_dlg_acknowledged, true
    render :text => "OK"
  end


end