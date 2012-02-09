class Notifier < ActionMailer::Base
default :from => "admin@sierraserviceproject.com"
  def password_email(user)
    mail( :to => user.email,
    :subject => 'SSP Password Reset Request',
    :body => password_reset_body(user))
  end

  def password_reset_body(user)
    body = "Dear #{user.name},

We have received a request to reset your MySSP password. To change your password, click on the link below.

 admin_users/password/edit?#{user.reset_password_token}

Meghan Osborn, SSP Business Manager

"
  end
end
