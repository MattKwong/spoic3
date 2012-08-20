require 'spec_helper'

def login_admin
  before (:each) do
    @request.env["devise.mapping"] = Devise.mappings[:admin_user]
    user = FactoryGirl.create(:admin_user)
    user.user_role.name = "Liaison"
    user.confirm!
    sign_in user
  end
end

describe RegistrationController do

  include Devise::TestHelpers
  render_views
  before (:each) do
   @base_title = "Sierra Service Project Online Information Center | "
  end

  describe "Get 'Create a Registration'" do
    login_admin
    it "should be successful" do
      get 'register'
      response.should be_success
    end

    it "should have the right title" do
      get 'register'
      response.should have_selector("title", :content => @base_title + "Register A Group")
    end

    #Random test
    #describe AdminUser do
    #  it "allows access to username attribute" do
    #    admin_user = AdminUser.new(username: 'seth')
    #    admin_user.username.should eq('seth')
    #  end
    #end

  end

end