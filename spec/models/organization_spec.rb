require 'spec_helper'

describe Organization do
  before (:each) do
    @attr = { :name => "Generic Organization"}
  end

  it "should create a new instance with valid attributes" do
    Organization.create!(@attr)
  end

  it "name should not be blank" do
    no_name = Organization.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end

  it "name should be unique" do
    item1 = Organization.create!(@attr)
    item2 = Organization.new(@attr)
    item2.should_not be_valid
  end
end