Rails::Engine.mixin __FILE__
class TwitterController < ApplicationController
  # overwritten so we can look up the Question
  def build_tweet_button
    templ = TwitterShareTemplate.random.active.first
    question = Question.find(params['question_id'])
    share = TwitterShare.create(
        :twitter_share_template_id => templ.id,
        :timestamp => Time.now.to_i,
        :inviter_id => @user.id,
        :tracking_object_id => question.id
    )
    render :partial => "partials/tweet_button", :locals => {:twitter_share_template => templ, :tracking_object => question, :share => share}
  end
end