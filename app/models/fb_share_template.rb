Rails::Engine.mixin __FILE__
class FbShareTemplate < ActiveRecord::Base
  def self.question_types
    FbShareTemplate.select("DISTINCT question_type").map(&:question_type)
  end

  def build_message(tracking_object, sharer)
    subs(message, tracking_object, sharer)
  end

  def build_link(tracking_object, timestamp)
    # unfortunately we have to build this link by hand here?
    "http://#{SEED_BLOCKS_ENGINE_CONFIG[:host]}/question/#{tracking_object.id}?cmfb=#{timestamp}"
  end

  def build_link_display(tracking_object, sharer)
    subs(link_display, tracking_object, sharer)
  end

  def build_image(question)
    question.public? && question.photo.url ? question.photo.thumb.url : "http://#{SEED_BLOCKS_ENGINE_CONFIG[:host]}/assets/questions/default_share_image.jpg"
  end

  def build_caption(tracking_object, sharer)
    subs(caption, tracking_object, sharer)
  end

  def build_description(tracking_object, sharer)
    subs(description, tracking_object, sharer)
  end

  private

  def subs(str, question, inviter)
    return '' if str.nil?
    str.gsub! "*question_text*", question.try(:question_text_pretty) || ""
    str.gsub! "*inviter_first*", inviter.first_name
    str.gsub! "*inviter_last*", inviter.last_name
    str.gsub! "*inviter_last_init*", inviter.last_name[0,1]
    str.gsub! "*inviter_full_name*", inviter.first_name + " " + inviter.last_name
    str.gsub! "*inviter_email*", inviter.email
    str
  end
end