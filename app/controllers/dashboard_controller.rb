Rails::Engine.mixin __FILE__
class DashboardController < ApplicationController
  def index
    Time.zone = "Central Time (US & Canada)"
    @collection_filter = params['coll'] || "questions"
    if @collection_filter == "questions"
      @collection = @user.questions.order("created_at DESC").paginate(:page => params['page'])
    else
      @collection = @user.answers.order("created_at DESC").paginate(:page => params['page'])
    end
  end
end