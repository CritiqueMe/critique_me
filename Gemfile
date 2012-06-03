source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

# Because these are failing to get propagated
# from seed_blocks.gemspec
# see:  https://github.com/carlhuda/bundler/issues/1041
#
group :development do
      gem "annotate"
      gem "test-unit"
      gem "mynyml-redgreen"
      gem "factory_girl", "~> 3.2.0"
      gem "factory_girl_rails", "~> 3.2.0"
      gem "awesome_print"
      gem "shoulda"
      gem "mocha"
      gem "test_benchmark"
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
#
# For Ruby 1.9.3
# see: http://stackoverflow.com/questions/8087610/ruby-debug-with-ruby-1-9-3
#
# source 'https://gems.gemfury.com/8n1rdTK8pezvcsyVmmgJ/' 
# gem 'linecache19',       '>= 0.5.13'
# gem 'ruby-debug-base19', '>= 0.11.26'
# gem 'ruby-debug19'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
gem "sendgrid"
#gem "compass", ">= 0.12.alpha", :group => :assets
gem "compass-rails", :group => :assets
gem "engineyard", :group => :development

#gem "seed_blocks", :path => "../../seed_blocks"
gem "seed_blocks", :git => "git@github.com:jgeggatt/SeedBlocks.git", :ref => "6ee4ccc041"




