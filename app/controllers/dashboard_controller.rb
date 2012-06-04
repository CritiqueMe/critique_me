Rails::Engine.mixin __FILE__
class DashboardController < ApplicationController
  layout "cm"

  def index
    Time.zone = "Central Time (US & Canada)"
    @collection_filter = params['coll'] || "questions"
    if @collection_filter == "questions"
      @collection = @user.questions.where(:active => true).order("created_at DESC").paginate(:page => params['page'])
    else
      @collection = @user.answers.order("created_at DESC").paginate(:page => params['page'])
    end
    @last_five_questions = Question.order('created_at DESC').limit(5)
  end
end