class QuestionsController < ApplicationController
  layout 'prototype'

  before_filter :enforce_login

  def question
    @question = Question.find(params['id'])
  end

  def new_question
    if params['question']
      @question = Question.new(params['question'])
      @question.user_id = @user.id
      @question.multiple_choice_options.delete_all unless @question.question_type == Question::QUESTION_TYPES.index(:multiple_choice)
      @question.save
      if @question.valid?
        post_question_to_open_graph(@question) if @question.post_to_wall
        redirect_to share_path(@question)
      else
        render :partial => "questions/form"
      end
    else
      @question = Question.new(:question_type => Question::QUESTION_TYPES.index(:multiple_choice))
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
        redirect_to share_path(@question)
      else
        render :partial => "questions/form"
      end
    end
  end

  def choose_question
    if request.post?
      @default_question = DefaultQuestion.find(params['id'])
      @question = Question.create_from_default_question(@default_question, @user)
      if @question.valid?
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
          questions << Question.create_from_default_question(dq, @user)
        end
      end
      redirect_to share_path(questions.first)
    end
  end


  private

  def post_question_to_open_graph(question)
    token = ''
    `curl -F 'question=#{question_url(question)}' -F 'access_token=#{token}' https://graph.facebook.com/me/#{SEED_BLOCKS_ENGINE_CONFIG[:fb_app_namespace]}:ask`
  end
end