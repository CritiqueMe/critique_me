Rails::Engine.mixin __FILE__
class Experiment < ActiveRecord::Base
  PATH_EVENTS = ["register", "invites_sent", "fb_oauth_button_click"]
end