host = case Rails.env
         when "production" then "critique_me.com"
         when "staging" then "critique_me_stg.com"
         else "critique_me.local:3000"
       end

# SeedBlocks config
SEED_BLOCKS_ENGINE_CONFIG = {
    :app_name             => "Critique Me",
    :user_validations     => [:password, :first_name, :last_name, :birthday],
    :fb_app_id            => "",
    :fb_app_secret        => "",
    :default_from_address => "contact@critique_me.com",
    :host                 => host,
    :http_authenticate    => ["staging", "production"],
    :http_basic_id        => "critique_me",
    :http_basic_pass      => "cr1t1qu3"
}
