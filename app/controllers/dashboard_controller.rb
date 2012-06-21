Rails::Engine.mixin __FILE__
class DashboardController < ApplicationController
  layout "cm"

  def index
    Time.zone = "Central Time (US & Canada)"
    @collection_filter = params['coll'] || "questions"
    @per_page = 10
    if @collection_filter == "questions"
      scope = @user.questions.where(:active => true, :canned_question_id => nil).order("created_at DESC")
    else
      scope = @user.answers.joins('JOIN questions ON answers.question_id=questions.id').
          where('questions.canned_question_id IS NULL').order("created_at DESC")
    end
    @num_records = scope.count
    @collection = scope.paginate(:page => params['page'], :per_page => @per_page)
    @last_five_questions = DefaultQuestion.active.featured.order('last_asked_at DESC')
  end
end