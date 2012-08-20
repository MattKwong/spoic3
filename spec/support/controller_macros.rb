module ControllerMacros

  #Rick's New stuff

  #def login_admin
  #  before (:each) do
  #    @request.env["devise.mapping"] = Devise.mappings[:admin_user]
  #    sign_in FactoryGirl.create(:admin_user)
  #  end
  #end
  #
  #def login_liaison
  #  before (:each) do
  #    @request.env["devise.mapping"] = Devise.mappings[:admin_user]
  #    sign_in FactoryGirl.create(:liaison_user)
  #  end
  #end


  #def login_admin
  #  before(:each) do
  #    @request.env["devise.mapping"] = :admin_user
  #    @user = FactoryGirl.create(:admin_user)
  #    @user.confirm!
  #    sign_in @user
  #  end
  #end

  #Old Login Stuff
  #def login_admin
  #  before (:each) do
  #    @request.env["devise.mapping"] = Devise.mappings[:admin_user]
  #    user = Factory.create(:admin_user)
  #    user.confirm!
  #    sign_in user
  #  end
  #end
end