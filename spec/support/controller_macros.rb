module ControllerMacros

  def login_admin
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      sign_in FactoryGirl.create(:admin_user)
    end
  end

  def login_liaison
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      sign_in FactoryGirl.create(:liaison_user)
    end
  end
end