Rails::Engine.mixin __FILE__
class ApplicationController < ActionController::Base
  private

  def post_question_to_open_graph(question)
    token = session[:fb_access_token]
    response = `curl -s -F 'question=#{question_url(question)}' -F 'access_token=#{token}' 'https://graph.facebook.com/me/#{Facebook::CONFIG["namespace"]}:ask'`
    Rails.logger.info "posted question to open graph, response = #{response}"
    json = JSON.parse(response)
    question.update_attribute :fb_question_id, json["id"]
  end
end

