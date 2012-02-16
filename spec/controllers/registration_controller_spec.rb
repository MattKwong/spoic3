require 'spec_helper'

describe RegistrationController do

  include Devise::TestHelpers
  render_views
  before (:each) do
   @base_title = "Sierra Service Project Online Information Center"
  end

  describe "Get 'Create a Registration'" do
    login_admin
    it "should be successful" do
      get 'register'
      response.should be_success
    end

    it "should have the right title" do
      get 'register'
      response.should have_selector("title", :content => @base_title + " | Register A Group")
    end
  end

end