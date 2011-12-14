ActiveAdmin.register AdminUser do
    menu :priority => 7
  after_create { |admin| admin.send_reset_password_instructions }

  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  form do |f|
    f.inputs "Liaison Details" do
      f.input :email
    end
    f.buttons
    end

  def password_required?
    new_record? ? false : super
  end

end

