gvis has been added in the SB generated Gemfile.   Adding manually.

config/initializers/koala.rb
config/facebook.yml

Had to add gem koala to Gemfile.   Doesn't like it in seedblocks.gemspec ?

cp ../../../SeedBlocks/db/migrate/20120430200639_create_seed_blocks_levels.rb .   # Needed because User has an initializer on create that initializes the user level.
rake db:migrate

UserLevels::initialize : Check if levels are defined before trying to assign a level.

undefined method `friends_updated_at_changed?' for #<User:0x000001030a24c8>
Need migration: 20120430200639_create_seed_blocks_levels.rb

undefined method `event_triggers' for #<CritiqueMe::Application:0x000001037a3380>
Add to application.rb:
 # For use with EventTrigger module
    # Persists trigger in development env
    @@event_triggers = {}
    cattr_accessor :event_triggers

undefined method `last_login=' for #<User:0x00000103765030>
Need migration: 20120520220000_add_last_login.rb

Mysql2::Error: Table 'critique_me.login_histories' doesn't exist: SHOW FIELDS FROM `login_histories`
Need migration: 20120525224338_create_login_history.rb

Mysql2::Error: Table 'critique_me.login_histories' doesn't exist: SHOW FIELDS FROM `login_histories`
Add to config/initializers/inflections.rb:
   inflect.irregular 'order_history', 'order_history'
   inflect.irregular 'login_history', 'login_history'

undefined method `buttons' for #<Formtastic::FormBuilder:0x000001031390f8>
