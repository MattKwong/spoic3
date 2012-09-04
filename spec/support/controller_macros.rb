module ControllerMacros

  def login_admin
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @current_admin_user = FactoryGirl.create(:admin_user)
      sign_in @current_admin_user
      @current_admin_user.confirm!
    end


  end

  def login_liaison
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      sign_in FactoryGirl.create(:liaison_user)
    end
  end
end