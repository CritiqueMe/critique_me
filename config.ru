# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

use Rack::CanonicalHost do
  case ENV['RACK_ENV'].to_sym
    when :staging then "www.critiquestg.com"
    when :production then "www.critiqueme.com"
  end
end

run CritiqueMe::Application
