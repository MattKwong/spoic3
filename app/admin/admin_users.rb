ActiveAdmin.register AdminUser do
   controller.authorize_resource
   menu :if => proc{ can?(:read, AdminUser) },:parent => "Users and Logs"
    show :title => :name
#    after_create { |admin| admin.send_reset_password_instructions }

  index do
    column :email
    column :name
    column :phone
    column :username
    column :user_role
    column :site
    column :liaison_id
    #column :password
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      #f.input :password
      f.input :phone
      f.input :user_role
      f.input :username, :hint => "Assign name to all site staff - no spaces"
      f.input :site
    end
    f.buttons
    end

  def password_required?
    new_record? ? false : super
  end

end

