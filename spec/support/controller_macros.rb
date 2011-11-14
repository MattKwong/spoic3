module ControllerMacros

  def login_admin
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in Factory.create[:admin]
    end
  end
end