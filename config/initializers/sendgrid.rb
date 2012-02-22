#ActionMailer::Base.logger = nil
ActionMailer::Base.delivery_method = Rails.env == 'test' ? :test : :smtp
ActionMailer::Base.perform_deliveries = Rails.env != 'test'
ActionMailer::Base.smtp_settings = {
    :address => "smtp.sendgrid.net",
    :port => 25,
    :authentication => :plain,
    :domain => "critique_me.com",
    :user_name => "seedblocks",
    :password => "momoney123"
}