require 'spec_helper'

describe PagesController do
  include Devise::TestHelpers
  render_views
  login_admin

  it "should have a current user" do
    subject.current_admin_user.should_not be_nil
  end

  describe "GET 'home'" do
    @base_title = "SSP Information Center"
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title", :content => "Welcome")
    end
  end

  describe "GET 'contact'" do
    @base_title = "SSP Information Center"
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title", :content => "Contact")
    end
  end
  describe "GET 'about'" do
    @base_title = "SSP Information Center"
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title", :content => "About")
    end
  end

  describe "GET 'help'" do
    @base_title = "SSP Information Center"
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title", :content => "Help ")
    end
  end


end