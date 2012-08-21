require 'spec_helper'
require "cancan/matchers"

describe SessionsController do
  include Devise::TestHelpers
  include ControllerMacros
  render_views
  #login_admin

  #Test pages/home.html
  describe "GET 'new'" do
    it "should be successful" do
      #build_resource
      response.should be_success
    end

  end

end