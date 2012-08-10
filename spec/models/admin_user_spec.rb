require 'spec_helper'

describe AdminUser do
  before (:each) do
    @attr = { :email => "valid@example.com", :name => "John Smith", :first_name => "John", :last_name => "Smith", :user_role_id => UserRole.find_by_name("Admin").id,
              :username => "JSmith1"  }
  end

  describe "Valid entries" do
    it "should create a valid admin entry" do
      valid_admin = AdminUser.new(@attr)
      valid_admin.should be_valid
    end
    it "should create a valid liaison entry" do
      valid_liaison = AdminUser.new(@attr.merge(:liaison_id => 1, :admin => false, :user_role_id => UserRole.find_by_name("Liaison").id))
      valid_liaison.should be_valid
    end
    it "should create a valid staff entry" do
      valid_staff = AdminUser.new(@attr.merge(:site_id => 1, :admin => false, :user_role_id => UserRole.find_by_name("Staff").id,
                                  :phone => "1234567890"))
      valid_staff.should be_valid
    end
  end

  describe "common to all user types" do
    it "should require an email" do
      no_email = AdminUser.new(@attr.merge(:email => ""))
      no_email.should_not be_valid
    end

    it "should reject an invalid email" do
      bad_email = AdminUser.new(@attr.merge(:email => "info@example"))
      bad_email.should_not be_valid
    end

    it "should reject a duplicate email" do
      good_email = AdminUser.new(@attr)
      good_email.save
      dup_email = AdminUser.new(@attr.merge(:first_name => "Duplicate", :last_name => "Email"))
      dup_email.should_not be_valid
    end

    it "should require a first name" do
      no_first = AdminUser.new(@attr.merge(:first_name => ""))
      no_first.should_not be_valid
    end
    it "should require a last name" do
      no_last = AdminUser.new(@attr.merge(:last_name => ""))
      no_last.should_not be_valid
    end
    it "should require a a valid phone number" do
      no_last = AdminUser.new(@attr.merge(:phone => "x123"))
      no_last.should_not be_valid
    end
  end

  describe "staff user tests" do
    it "should require a site id" do
      no_site = AdminUser.new(@attr.merge(:admin => false, :user_role_id => UserRole.find_by_name("Staff").id, :site_id => ""))
      no_site.should_not be_valid
    end
    it "should require a nonnegative integer site id" do
      no_site = AdminUser.new(@attr.merge(:admin => false, :user_role_id => UserRole.find_by_name("Staff").id, :site_id => 0))
      no_site.should_not be_valid
    end
    #it "should require a site id that points to a valid site" do
    #
    #end


  end
  #  it "should require a activity details" do
  #    no_details_txn = Activity.new(@attr.merge(:activity_details => ""))
  #    no_details_txn.should_not be_valid
  #  end
  #
  #  it "should require a activity type" do
  #    no_type_txn = Activity.new(@attr.merge(:activity_type => ""))
  #    no_type_txn.should_not be_valid
  #  end
  #
  #  it "should require a user id" do
  #    no_user_txn = Activity.new(@attr.merge(:user_id=> ""))
  #    no_user_txn.should_not be_valid
  #  end
  #
  #  it "should require a user name" do
  #    no_name_txn = Activity.new(@attr.merge(:user_name=> ""))
  #    no_name_txn.should_not be_valid
  #  end
  #end
  #
  #describe "Data type tests" do
  #  it "should require a valid date" do
  #    invalid_date_txn = Activity.new(@attr.merge(:activity_date=> "xyz"))
  #    invalid_date_txn.should_not be_valid
  #  end
  #
  #  it "user id should be nonnegative integer" do
  #    invalid_user_id_txn = Activity.new(@attr.merge(:user_id=> 0))
  #    invalid_user_id_txn.should_not be_valid
  #  end
  #end
  #
  #describe "Valid entry" do
  #  it "should create a valid entry" do
  #    valid_txn = Activity.new(@attr)
  #    valid_txn.should be_valid
  #  end
  #end

end

