require 'spec_helper'

#sign in - to make these tests work without having a signed in user, I commented out the tests in the
#_header partial to eliminate the signed_in? test
@current_admin_user = AdminUser.new()

describe PagesController do
  render_views

  before (:each) do
    @base_title = "Sierra Service Project Online Information Center "
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title", :content => @base_title + "| Welcome")
    end
  end




  describe "Get 'Tabatha'" do
    it "should be successful" do
      get 'food'
      response.should be_success
    end
    it "should have the right title" do
      get 'food'
      response.should have_selector("title", :content => @base_title + "| Tabatha")
    end end

  describe "Get 'CTAB'" do
    it "should be successful" do
      get 'construction'
      response.should be_success
    end

    it "should have the right title" do
      get 'construction'
      response.should have_selector("title", :content => @base_title + "| CTAB")
    end
  end

end