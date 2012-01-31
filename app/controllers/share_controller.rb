#Rails::Engine.mixin __FILE__
class ShareController < ApplicationController
  def index
    @question = Question.find(params['question_id'])
    render :partial => "share/dialog"
  end
end