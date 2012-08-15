Rails::Engine.mixin __FILE__
class ReferralController < ApplicationController

  def incoming
    Rails.logger.info "****** #{params['token']} -- #{params['token'].length == 4}"
    if params['token'].length == 4
      q = Question.where(:id => params['question_id']).first
      if q && q.user.referral_token[q.user.referral_token.length-4, 4] == params['token']
        session[:referrer_id] = q.user_id
        session[:clicked_question_id] = q.id
      end
    else
      get_referrer
    end
    create_viral_entrance("referral_link")
    redirect_to welcome_path
  end

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
      session[:clicked_question_id] = share.tracking_object_id
    end
  end
end