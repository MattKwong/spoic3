require 'spec_helper'

describe Church do
  before (:each) do
    @attr = { :name => "First Church", :address1 => "4410 S. Budlong Avenue", :city => "Los Angeles", :state => "CA", :zip => "90037"}
  end

  it "should require a name" do
    no_name_church = Church.new(@attr.merge(:name => ""))
    no_name_church.should_not be_valid
  end

  it "should reject a short name" do
    short_name = "a" * 5
    short_name_church = Church.new(@attr.merge(:name => short_name))
    short_name_church.should_not be_valid
  end

  it "should accept a valid name" do
    church = Church.new(@attr)
    church.should be_valid
  end

  it "should reject a long name" do
    long_name = "a" * 41
    long_name_church = Church.new(@attr.merge(:name => long_name))
    long_name_church.should_not be_valid
  end

  it "should require an address1" do
    no_add1_church = Church.new(@attr.merge(:address1 => ""))
    no_add1_church.should_not be_valid
  end

  it "should require a city" do
    no_city_church = Church.new(@attr.merge(:city => ""))
    no_city_church.should_not be_valid
  end

  it "should require a state" do
    no_state_church = Church.new(@attr.merge(:state => ""))
    no_state_church.should_not be_valid
  end

  describe "state should be valid 2-letter upper case abbreviation" do
    it "should be in valid states list" do

    end

  end


end