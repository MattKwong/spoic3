class Notifier < ActionMailer::Base
default :from => "admin@sierraserviceproject.com"
  def password_email(user)
    @user = user
    mail( :to => user.email,
    :subject => 'SSP Password Reset Request')
  end


end
