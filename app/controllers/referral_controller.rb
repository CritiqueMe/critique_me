Rails::Engine.mixin __FILE__
class ReferralController < ApplicationController
  private

  def create_twitter_entrance
    if(share = TwitterShare.find(params[:token]) rescue false)
      tracker = TwitterEntrance.create(
          :twitter_share_template_id => share.twitter_share_template_id,
          :inviter_id => share.inviter_id,
          :tracking_object_id => share.tracking_object_id
      )
      session[:twitter_entrance_id] = tracker.id
      share.clicked!
      session[:clicked_question_id] = share.tracking_question_id
    end
  end
end