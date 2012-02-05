# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Spoic3::Application.initialize!

#Rails::Initializer.run do
#  config.gem "cancan"
#end

ActionMailer::Base.delivery_method = :smtp
#config.time_zone = "Pacific Time (US & Canada)"

#ActionMailer::Base.smtp_settings = {
#  :address              => "sierraserviceproject.org",
#  :port                 => 25,
#  :user_name            => "director@sierraserviceproject.org",
#  :password             => "norge1",
#  :authentication       => nil #,
#  :enable_starttls_auto => true
#}

