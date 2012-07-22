class ApplicationController < ActionController::Base
  protect_from_forgery :only => [:create, :update]
  add_breadcrumb "Home", '/'

  rescue_from Timeout::Error, :with => :rescue_from_timeout

  protected

  def after_sign_in_path_for(resource)
 #this overrides the default method in the devise library

   program_user = ProgramUser.find_by_user_id(resource.id)

   if resource.liaison?
     liaison = Liaison.find(resource.liaison_id)
     church = Church.find(liaison.church_id)
     if church.nil? #the liaison is unassigned to a church, so he/she can't do anything
       log_activity(Time.now, "Invalid Login", "Unassigned to church - logged off", resource.id, resource.name, resource.user_role)     #redirect_to :back
       destroy_admin_user_session_path #log out
     else
       log_activity(Time.now, "Liaison Login", "Logged on to system", resource.id, resource.name, resource.user_role)
       return myssp_path(liaison.id)
     end
   else
   if resource.admin?
     log_activity(Time.now, "Admin Login", "Logged on to system", resource.id, resource.name, resource.user_role)
     return '/admin'
   else
     if resource.construction_admin?
       log_activity(Time.now, "Construction Admin Login", "Logged on to system", resource.id, resource.name, resource.user_role)
       return ops_pages_show_path
     else
       if resource.food_admin?
         log_activity(Time.now, "Food Admin Login", "Logged on to system", resource.id, resource.name, resource.user_role)
         return ops_pages_show_path
       else
         if resource.staff?
           program_user = ProgramUser.find_by_user_id(resource.id)
           log_activity(Time.now, "#{program_user.job.job_type.name} Login", "Logged on to system", resource.id, resource.name, resource.user_role)
             return program_path(program_user.program_id)
         end
       end
     end
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

  private
  def rescue_from_timeout
    log_activity(Time.now, "Error", "System timeout error", @current_admin_user.id, current_admin_user.name, "")
    redirect_to timeout_error_path
  end
end
