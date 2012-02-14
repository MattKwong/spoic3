class PasswordsController < Devise::PasswordsController
  #prepend_before_filter :require_no_authentication
  skip_before_filter :require_no_authentication
  include Devise::Controllers::InternalHelpers
  layout 'admin_layout'

# GET /resource/password/new
  def new
    @page_title = "Reset your password"
    build_resource({})
    render_with_scope :new
  end

  # POST /resource/password
  def create
    h = params[:admin_user]
    user = AdminUser.find_by_email(h["email"])

    if user
      self.resource = resource_class.send_reset_password_instructions(params[resource_name])
#      logger.debug "In passwords_controller#{user.inspect}"
#      logger.debug "In passwords_controller#{resource.inspect}"
      Notifier.password_email(resource).deliver
#      respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
      flash[:notice] = "Password reset instructions have been sent to #{resource.email}"
    else
      flash[:error] = "This email is not registered with the MySSP system."
    end
    redirect_to :root
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    @page_title = "Reset Your Password"
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    render_with_scope :edit
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(params[resource_name])
    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      log_activity(Time.now, "Password Change", "Successful password change",
                   resource.id, resource.name, resource.user_role)
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      @page_title = "Reset Your Password"
      respond_with_navigational(resource){ render_with_scope :edit }
    end
  end

  protected

    # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_session_path(resource_name)
  end

  def log_activity(time, activity_type, activity_details, id, name, user_role)
    logger.debug resource.inspect
    a = Activity.new
    a.activity_date = time
    a.activity_type = activity_type
    a.activity_details = activity_details
    a.user_id = id
    a.user_name = name
    a.user_role = user_role
    unless a.save!
      flash[:error] = "Unknown problem occurred logging a transaction."
    end
  end
end
