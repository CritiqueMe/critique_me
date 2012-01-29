Rails::Engine.mixin __FILE__
class DashboardController < ApplicationController
  def index
    @collection_filter = params['coll'] || "questions"
    if @collection_filter == "questions"
      @collection = Question.order("created_at DESC").paginate(:page => params['page'])
    else
      @collection = Answer.order("created_at DESC").paginate(:page => params['page'])
    end
  end
end