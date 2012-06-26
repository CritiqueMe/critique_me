Rails::Engine.mixin __FILE__
class ReferralController < ApplicationController
  private

  def get_tracking_object
    session[:tracking_object_id] = params[:tracking_object_id]
    session[:clicked_question_id] = params[:tracking_object_id]
  end
end