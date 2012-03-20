Rails::Engine.mixin __FILE__
class FbShareTemplate < ActiveRecord::Base
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

  def build_image(tracking_object)
    tracking_object.photo.try(:thumb).try(:url)
  end

  def build_caption(tracking_object, sharer)
    subs(caption, tracking_object, sharer)
  end

  def build_description(tracking_object, sharer)
    subs(description, tracking_object, sharer)
  end

  private

  def subs(str, question, inviter)
    str.gsub! "*question_text*", question.question_text_pretty
    str.gsub! "*inviter_first*", inviter.first_name
    str.gsub! "*inviter_last*", inviter.last_name
    str.gsub! "*inviter_last_init*", inviter.last_name[0,1]
    str.gsub! "*inviter_full_name*", inviter.first_name + " " + inviter.last_name
    str.gsub! "*inviter_email*", inviter.email
    str
  end
end