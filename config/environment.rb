# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Spoic3::Application.initialize!

#ActionMailer::Base.default_url_options[:host] = "sierraserviceproject.org"
ActionMailer::Base.delivery_method = :sendmail

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.sierraserviceproject.org",
  :port                 => 25,
  :domain               => "sierraserviceproject.org",
  :user_name            => "director",
  :password             => "norge1",
#  :authentication       => 'login',
  :enable_starttls_auto => true
}

