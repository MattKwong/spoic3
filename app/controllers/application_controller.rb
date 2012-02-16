class ApplicationController < ActionController::Base
  protect_from_forgery

 def after_sign_in_path_for(resource)
 #this overrides the default method in the devise library

    if resource.liaison?
       liaison = Liaison.find(resource.liaison_id)
       church = Church.find(liaison.church_id)
       if church.nil? #the liaison is unassigned to a church, so he/she can't do anything
         log_activity(Time.now, "Invaild Login", "Unassigned to church - logged off", resource.id, resource.name, resource.user_role)     #redirect_to :back
         destroy_admin_user_session_path #log out
       else
        log_activity(Time.now, "Liaison Login", "Logged on to system", resource.id, resource.name, resource.user_role)
        myssp_path(liaison.id)
      end
    else if resource.admin?
      log_activity(Time.now, "Admin Login", "Logged on to system", resource.id, resource.name, resource.user_role)
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
    resource ||= @current_admin_user
    flash[:error] = "Error: You are not authorized to perform this action."
    if resource.liaison?
      redirect_to myssp_path(resource.liaison_id)
    else if resource.admin?
      redirect_to '/admin'
         end
    end
  end
end
