require 'spec_helper'

describe SessionType do
  before (:each) do
    @attr = { :name => "A Session Type", :description => "ST Description"}
  end

  it "should create a new instance with valid attributes" do
    item = SessionType.create!(@attr)
    item.should be_valid
  end

  it "name should not be blank" do
    item = SessionType.new(@attr.merge(:name => ''))
    item.should_not be_valid
  end

  it "name should be unique" do
    item1 = SessionType.create!(@attr)
    item2 = SessionType.new(@attr)
    item2.should_not be_valid
  end

  it "description should not be blank" do
    item = SessionType.new(@attr.merge(:description => ''))
    item.should_not be_valid
  end

end