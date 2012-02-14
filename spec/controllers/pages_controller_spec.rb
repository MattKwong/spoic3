require 'spec_helper'

describe PagesController do
  include Devise::TestHelpers
  render_views


  describe "GET 'home'" do
    login_admin
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