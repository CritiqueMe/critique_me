# Be sure to restart your server when you modify this file.

domain = Rails.env.production? ? 'critiqueme.com' : (Rails.env.staging? ? 'critiquestg.com' : 'critiqueme.local')
FoodieRewards::Application.config.session_store :cookie_store, key: '_critique_me_session', :domain => domain

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# CritiqueMe::Application.config.session_store :active_record_store
