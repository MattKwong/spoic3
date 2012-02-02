class ApplicationController < ActionController::Base
  protect_from_forgery

 def after_sign_in_path_for(resource)
 #this overrides the default method in the devise library
    log_activity(Time.now, "Login", "Logged on to system", resource.id, resource.name, resource.user_role)
    if resource.liaison?
      liaison = Liaison.find_by_email1(resource.email)
      myssp_path(liaison.id)
    else if resource.admin?
      '/admin'
      end
    end
 end

  def current_ability
    @current_ability ||= Ability.new(current_admin_user)
  end

  def log_activity(activity_date, activity_type, activity_details, user_id, user_name, user_role)

    a = Activity.new
    a.activity_date = activity_date
    a.activity_type = activity_type
    a.activity_details = activity_details
    a.user_id = user_id
    a.user_name = user_name
    a.user_role = user_role
    unless a.save!
      flash[:error] = "Unknown problem occurred logging a transaction."
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Error: You are not authorized to perform this action"
    redirect_to '/'
  end
end
