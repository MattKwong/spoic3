require 'spec_helper'

describe ApplicationController do
  include Devise::TestHelpers
  render_views
  describe "Admin Login" do
    login_admin

    it "should have a current user" do
      subject.current_admin_user.should_not be_nil
    end

    it "current user should be an admin" do
      subject.current_admin_user.admin?.should be_true
    end

    end

  describe "Liaison Login" do
    liaison_admin

    it "should have a current user" do
      subject.current_admin_user.should_not be_nil
    end

    it "current user should be an liaison" do
      subject.current_admin_user.liaison?.should be_true
    end

  end

#should test routes to admin, liaison and staff logons
#should test that activity log is written to

end