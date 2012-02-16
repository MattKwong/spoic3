require 'spec_helper'

describe PagesController do
  include Devise::TestHelpers
  render_views


  describe "GET 'home'" do
    @base_title = "SSP Information Center"
    login_admin
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title", :content => "Welcome")
    end
  end

  describe "Get 'Tabatha'" do
    @base_title = "SSP Information Center"
    login_admin
    it "should be successful" do
      get 'food'
      response.should be_success
    end
    it "should have the right title" do
      get 'food'
      response.should have_selector("title", :content => "Tabatha")
    end end

  describe "Get 'CTAB'" do
    @base_title = "SSP Information Center"
    login_admin
    it "should be successful" do
      get 'construction'
      response.should be_success
    end

    it "should have the right title" do
      get 'construction'
      response.should have_selector("title", :content => "CTAB")
    end
  end

end