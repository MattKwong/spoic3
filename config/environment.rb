# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Spoic3::Application.initialize!

#Rails::Initializer.run do
#  config.gem "cancan"
#end

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.sierraserviceproject.org",
  :port                 => 25,
  :user_name            => "director@sierraserviceproject.org",
  :password             => "norge1",
  :authentication       => 'plain',
  :enable_starttls_auto => true
}

