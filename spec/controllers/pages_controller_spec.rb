require 'spec_helper'

describe PagesController do
  include Devise::TestHelpers
  render_views

  before(:each) do
    # Define @base_title here.
    @base_title = "SSP Online Information Center | "
  end

  #Test pages/home.html
  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
                                    :content => @base_title + "Welcome")
    end
  end

  # Test pages/about.html
  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                                    :content => @base_title + "About")
    end
  end

  # Test pages/contact.html
  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
                                    :content => @base_title + "Contact")
    end
  end

  # Test pages/help.html
  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
                                    :content => @base_title + "Help")
    end
  end

# Old Tests
# Tests pages/home
#  describe "GET 'home'" do
#    @base_title = "SSP Information Center"
#   #login_admin
#    it "should be successful" do
#      get 'home'
#      response.should be_success
#    end
#
#    it "should have the right title" do
#      get 'home'
#      response.should have_selector("title", :content => "Center")
#    end
#  end

  # Page no longer exists
  #describe "Get 'Tabatha'" do
  #  @base_title = "SSP Information Center"
  #  # login_admin
  #  it "should be successful" do
  #    get 'food'
  #    response.should be_success
  #  end
  #  it "should have the right title" do
  #    get 'food'
  #    response.should have_selector("title", :content => "Tabatha")
  #  end
  #end

  # Page no longer exists
  #describe "Get 'CTAB'" do
  #  @base_title = "SSP Information Center"
  #  # login_admin
  #  it "should be successful" do
  #    get 'construction'
  #    response.should be_success
  #  end
  #
  #  it "should have the right title" do
  #    get 'construction'
  #    response.should have_selector("title", :content => "CTAB")
  #  end
  #end

end