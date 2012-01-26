class LiaisonsController < ApplicationController
  def create_user
    liaison = Liaison.find(params[:id])
    user = AdminUser.new
    user.admin = false
    user.email = liaison.email1
    user.first_name = liaison.first_name
    user.last_name = liaison.last_name
    user.liaison_id = liaison.id
    user.name = liaison.name
    user.user_role = "Liaison"
    user.password = "password"

    unless user.save!
      flash[:error] = "A problem occurred in create a logon for this liaison."
    else
      liaison.user_created = true
      unless liaison.save!
        flash[:error] = "A problem occurred in updating logon information for this liaison."
      else
        redirect_to admin_liaison_path(liaison.id)
      end
    end
  end

  def password_required?
    new_record? ? false : super
  end

end