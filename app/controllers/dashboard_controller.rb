Rails::Engine.mixin __FILE__
class DashboardController < ApplicationController
  layout "cm"

  def index
    Time.zone = "Central Time (US & Canada)"
    @collection_filter = params['coll'] || "questions"
    @per_page = 10
    if @collection_filter == "questions"
      scope = @user.questions.where(:active => true).order("created_at DESC")
    else
      scope = @user.answers.order("created_at DESC")
    end
    @num_records = scope.count
    @collection = scope.paginate(:page => params['page'], :per_page => @per_page)
    @last_five_questions = Question.order('created_at DESC').limit(5)
  end
end