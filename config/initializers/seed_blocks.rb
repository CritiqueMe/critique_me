host = case Rails.env
         when "production" then "critique_me.com"
         when "staging" then "critique_me_stg.com"
         else "critique_me.local:3000"
       end

# SeedBlocks config
SEED_BLOCKS_ENGINE_CONFIG = {
    :app_name             => "critique_me",
    :user_validations     => [],
    :fb_app_id            => "",
    :fb_app_secret        => "",
    :default_from_address => "contact@critique_me.com",
    :host                 => host,
    :http_basic_id        => "critique_me",
    :http_basic_pass      => ""
}
