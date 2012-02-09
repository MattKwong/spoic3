class Notifier < ActionMailer::Base
default :from => "admin@sierraserviceproject.com"
  def password_email(user)
    mail( :to => user.email,
    :subject => 'Password request',
    :body => "Body of the message goes here, #{user.name}")
  end

end
