require 'spec_helper'

before (:each) do
   @base_title = "Sierra Service Project Online Information Center"
 end


describe RegistrationController do
    describe "Get 'Group Manager'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

  end


end