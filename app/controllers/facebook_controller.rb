Rails::Engine.mixin __FILE__
class FacebookController < ApplicationController

  def random_share_template
    q = Question.find_by_id params['tracking_id']
    if q
      render :json => FbShareTemplate.active.
          where(:question_type => q.canned_question_id ? 'canned' : (q.public? ? 'public' : 'private')).
          random.first
    else
      render :nothing => true
    end
  end
end