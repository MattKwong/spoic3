require 'spec_helper'

describe ChurchType do
  before (:each) do
    @attr = { :name => "Generic Church"}
  end

  it "should create a new instance with valid attributes" do
    ChurchType.create!(@attr)
  end

  it "name should not be blank" do
    no_name = ChurchType.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end

  it "name should be unique" do
    church1 = ChurchType.create!(@attr)
    church2 = ChurchType.new(@attr)
    church2.should_not be_valid
  end
end

