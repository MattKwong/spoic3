require 'spec_helper'

describe Activity do
  before (:each) do
    @attr = { :activity_date => DateTime.now, :activity_details => "Posting of new test transaction", :activity_type => "Adjustment", :user_id => 1,
              :user_name => "Current User" }
  end

  describe "Presence tests" do
    it "should require a activity_date" do
      no_date_txn = Activity.new(@attr.merge(:activity_date => ""))
      no_date_txn.should_not be_valid
    end

    it "should require a activity details" do
      no_details_txn = Activity.new(@attr.merge(:activity_details => ""))
      no_details_txn.should_not be_valid
    end

    it "should require a activity type" do
      no_type_txn = Activity.new(@attr.merge(:activity_type => ""))
      no_type_txn.should_not be_valid
    end

    it "should require a user id" do
      no_user_txn = Activity.new(@attr.merge(:user_id=> ""))
      no_user_txn.should_not be_valid
    end

    it "should require a user name" do
      no_name_txn = Activity.new(@attr.merge(:user_name=> ""))
      no_name_txn.should_not be_valid
    end
  end

  describe "Data type tests" do
    it "should require a valid date" do
      invalid_date_txn = Activity.new(@attr.merge(:activity_date=> "xyz"))
      invalid_date_txn.should_not be_valid
    end

    it "user id should be nonnegative integer" do
      invalid_user_id_txn = Activity.new(@attr.merge(:user_id=> 0))
      invalid_user_id_txn.should_not be_valid
    end
  end

  describe "Valid entry" do
    it "should create a valid entry" do
      valid_txn = Activity.new(@attr)
      valid_txn.should be_valid
    end
  end

end

