Rails::Engine.mixin __FILE__
class TrackingController < ApplicationController
  private

  def sb_handle_tracking_object(tracker)
    session[:clicked_question_id] = tracker.tracking_object_id
  end

  def sb_handle_already_signed_in_and_finished_with_path(tracker)
    redirect_to question_path(tracker.tracking_object_id)
  end
end