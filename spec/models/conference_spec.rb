require 'spec_helper'

describe Conference do
  before (:each) do
    @attr = { :name => "Generic Conference"}
  end

  it "should create a new instance with valid attributes" do
    Conference.create!(@attr)
  end

  it "name should not be blank" do
    no_name = Conference.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end

  it "name should be unique" do
    church1 = Conference.create!(@attr)
    church2 = Conference.new(@attr)
    church2.should_not be_valid
  end
end