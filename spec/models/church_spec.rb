require 'spec_helper'

describe Church do
  before (:each) do
    if Church.find_by_name("First Church")
      Church.find_by_name("First Church").delete
    end
    @attr = { :name => "First Church", :address1 => "4410 S. Budlong Avenue", :city => "Los Angeles", :state => "CA",
              :zip => "90037", :email1 => "info@example.com", :registered => false,
    :office_phone => "123-456-7890", :fax => "123-456-7890", :liaison_id => 1, :active => true, :church_type_id => 1 }
  end
  describe "Valid Church" do
    it "should be valid" do
      Church.new(@attr).should be_valid
    end
  end
  describe "Church name tests" do
    it "should require a name" do
      no_name_church = Church.new(@attr.merge(:name => ""))
      no_name_church.should_not be_valid
    end

    it "should reject a short name" do
      short_name = "a" * 5
      short_name_church = Church.new(@attr.merge(:name => short_name))
      short_name_church.should_not be_valid
    end

    it "should reject a long name" do
      long_name = "a" * 46
      long_name_church = Church.new(@attr.merge(:name => long_name))
      long_name_church.should_not be_valid
    end
  end
  
  describe "Address and city tests"  do
    it "should require an address1" do
      no_add1_church = Church.new(@attr.merge(:address1 => ""))
      no_add1_church.should_not be_valid
    end

    it "should require a city" do
      no_city_church = Church.new(@attr.merge(:city => ""))
      no_city_church.should_not be_valid
    end
  end
  
  describe "State tests" do
    
    it "should accept a valid state abbreviation" do
      good_state = Church.new(@attr)
      good_state.should be_valid
    end

    it "should require a state" do
      no_state_church = Church.new(@attr.merge(:state => ""))
      no_state_church.should_not be_valid
    end

    it "should be in a valid states abbreviation" do
      invalid_state_church = Church.new(@attr.merge(:state => "XX"))
      invalid_state_church.should_not be_valid
    end

  end
  
  describe "zip code tests" do

    it "should accept a valid zip code" do
      good_zip = Church.new(@attr)
      good_zip.should be_valid
    end

    it "should require a zip code" do
      no_zip = Church.new(@attr.merge(:zip => ""))
      no_zip.should_not be_valid
    end

    it "should be 5 digits" do
      bad_zip = Church.new(@attr.merge(:zip => "1234"))
      bad_zip.should_not be_valid
    end

    it "should only be digits" do
      bad_zip = Church.new(@attr.merge(:zip => "xxxxx"))
      bad_zip.should_not be_valid
    end

  end

  describe "email1 tests" do

    it "should allow a blank email" do
      no_email = Church.new(@attr.merge(:email1 => ""))
      no_email.should be_valid
    end

    it "should reject an invalid email" do
      bad_email = Church.new(@attr.merge(:email1 => "info@example"))
      bad_email.should_not be_valid
    end

    it "should reject a duplicate email" do
      good_email = Church.new(@attr)
      good_email.save
      dup_email = Church.new(@attr.merge(:name => "Duplicate email church"))
      dup_email.should_not be_valid
    end
  end
  
  describe "Office and Fax tests"
    it "should have an office phone" do
      no_phone = Church.new(@attr.merge(:office_phone => ""))
      no_phone.should_not be_valid
    end

    it "should reject an invalid office phone" do
      bad_phone = Church.new(@attr.merge(:office_phone => "123-4567"))
      bad_phone.should_not be_valid
    end

    it "should reject an invalid fax phone" do
      bad_phone = Church.new(@attr.merge(:fax => "123-4567"))
      bad_phone.should_not be_valid
    end
end
