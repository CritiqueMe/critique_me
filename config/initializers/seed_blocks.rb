host = case Rails.env
         when "production" then "critique_me.com"
         when "staging" then "critiquestg.com"
         else "critiqueme.local:3000"
       end

if Rails.env.production?
  fb_app_id = ""
  fb_app_secret = ""
  fb_app_namespace = "critique_me"
else
  fb_app_id = "162564120523137"
  fb_app_secret = "0dacd2ca12e020af25767fe78f4897e6"
  fb_app_namespace = "critique_me_stg"
end

# SeedBlocks config
SEED_BLOCKS_ENGINE_CONFIG = {
    :app_name             => "Critique Me",
    :user_validations     => [:password, :first_name, :last_name],
    :fb_app_id            => fb_app_id,
    :fb_app_secret        => fb_app_secret,
    :fb_app_namespace     => fb_app_namespace,
    :default_from_address => "contact@critique_me.com",
    :host                 => host,
    :http_authenticate    => ["production"],
    :http_basic_id        => "critique_me",
    :http_basic_pass      => "cr1t1qu3"
}
