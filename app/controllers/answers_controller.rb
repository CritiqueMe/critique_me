class AnswersController < ApplicationController


  def new
    if request.post?
      @answer = Answer.new(params['answer'])
      @answer.save
      flash[:notice] = "Answer Posted"
      redirect_to new_question_path
    else
      redirect_to dashboard_path
    end
  end
end