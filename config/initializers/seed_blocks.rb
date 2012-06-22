host = case Rails.env
         when "production" then "critiqueme.com"
         when "staging" then "critiquestg.com"
         else "critiqueme.local:3000"
       end

# SeedBlocks config
SEED_BLOCKS_ENGINE_CONFIG = {
    :app_name             => "Critique Me",
    :user_validations     => [:password, :first_name, :last_name],
    :default_from_address => "contact@critiqueme.com",
    :host                 => host,
    :http_authenticate    => ["staging"],
    :http_basic_id        => "critique_me",
    :http_basic_pass      => "cr1t1qu3"
}
