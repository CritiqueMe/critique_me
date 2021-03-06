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
          flash[:show_share] = true
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

  def write_question
    if @user && @user.id
      # todo
    else
      session[:path_written_question] = {
          :question_text => params['question']['question_text'],
          :question_type => params['question']['question_type'],
          :mc_options => params['question']['multiple_choice_options_attributes'].keys.map{|k| params['question']['multiple_choice_options_attributes'][k]['answer_text']}
      }
    end
    @tracker.log(:question_written, "User wrote a question")
    @tracker.converted = true if @experiment.conversion_event == "question_written"
    save_path_tracker
    increment_page
    redirect_to welcome_path
  end

  def manual_share
    if request.post?
      @question = Question.find(params['question_id'])
      invitees = params['emails'].gsub(" ", '').split(",").collect{|x| {:email => x}}
      Invite.queue_invites(@user, invitees, @question.id)

      @tracker.converted = true if @experiment.conversion_event == "invites_sent"
      @tracker.invites_sent = invitees.length
      @tracker.save

      after_inviting_contacts
      session[:show_oops] = !@question.shared_with_minimum?

      redirect_to welcome_path
    end
  end

  def invite_contacts
    # Create invite for each selected contact
    invitees = []
    imported_emails = params['imported_emails'].gsub(" ", "").split(",")
    imported_names = params['imported_names'] ? params['imported_names'].split(";") : []
    imported_emails.each_with_index do |c, i|
      invitees << {:email => c, :name => imported_names[i]} if params["contact_#{i}"]
    end
    @question = Question.find(params['question_id'])
    Invite.queue_invites(@user, invitees, @question.id)

    @tracker.converted = true if @experiment.conversion_event == "invites_sent"
    @tracker.invites_sent = invitees.length
    @tracker.save

    after_inviting_contacts
    session[:show_oops] = !@question.shared_with_minimum?

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
      @last_questions = DefaultQuestion.active.featured.order('RAND()')
    elsif @path_page.page_type == "choose_question" || @path_page.page_type == "choose_q_about_cm_dlg"
      @per_page = 7
      scope = DefaultQuestion.active.not_in_questionnaire.prioritized
      scope = scope.where(:category_id => params['category_id']) if params['category_id'] && params['category_id'] != ''
      @num_questions = scope.count
      @default_questions = scope.paginate(:page => params['page'], :per_page => @per_page)
      if @path_page.page_type == "choose_q_about_cm_dlg"
        @show_pitch_dlg = true
      end

      # Needed for "write question" page
      @ask_method = params['ask_method'] || 'choose'
      @default_question_text = "Ex: Am I a talented singer?"
      @default_mc_answer_text = "Enter answer choice"
      @last_five_questions = DefaultQuestion.active.featured.order('last_asked_at DESC')
      @question = Question.new(:question_type => Question::QUESTION_TYPES.index(:true_false))
      2.times do
        @question.multiple_choice_options.build
      end
    elsif @path_page.page_type == "share"
      @question = @user.questions.last
      session[:question_to_share] = @question.id
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
    elsif session[:path_written_question]
      @question = Question.new
      @question.question_text = session[:path_written_question][:question_text]
      @question.question_type = session[:path_written_question][:question_type]
      @question.user_id = @user.id
      if @question.save && @question.question_type == Question::QUESTION_TYPES.index(:multiple_choice)
        session[:path_written_question][:mc_options].each do |mc|
          @question.multiple_choice_options << MultipleChoiceOption.new(:answer_text => mc)
        end
        post_question_to_open_graph(@question) # TODO: ask for permission to do this
      end
      session[:path_written_question] = nil
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