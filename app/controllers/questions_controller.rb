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
        # fire invite dialog
      end
    else
      @question = Question.new(:question_type => Question::QUESTION_TYPES.index(:multiple_choice))
      3.times do
        @question.multiple_choice_options.build
      end
    end
  end

  def choose_question

  end
end