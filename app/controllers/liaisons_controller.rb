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
    user.password = user.reset_password_token = random_pronouncable_password

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

  def random_pronouncable_password(size = 4)
    c = %w(b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr)
    v = %w(a e i o u y)
    f, r = true, ''
    (size * 2).times do
      r << (f ? c[rand * c.size] : v[rand * v.size])
      f = !f
    end
  r
  end

end