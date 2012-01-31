class QuestionsController < ApplicationController
  layout 'prototype'

  before_filter :enforce_login

  def new_question
    if params['question']
      @question = Question.new(params['question'])
      @question.user_id = @user.id
      @question.multiple_choice_options.delete_all unless @question.question_type == Question::QUESTION_TYPES.index(:multiple_choice)
      @question.save
      if @question.valid?
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
end