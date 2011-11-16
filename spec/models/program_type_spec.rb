require 'spec_helper'

describe ProgramType do
  before (:each) do
    @attr = { :name => "A Program Type", :description => "PT Description"}
  end

  it "should create a new instance with valid attributes" do
    item = ProgramType.create!(@attr)
    item.should be_valid
  end

  it "name should not be blank" do
    item = ProgramType.new(@attr.merge(:name => ''))
    item.should_not be_valid
  end

  it "name should be unique" do
    item1 = ProgramType.create!(@attr)
    item2 = ProgramType.new(@attr)
    item2.should_not be_valid
  end

  it "description should not be blank" do
    item = ProgramType.new(@attr.merge(:description => ''))
    item.should_not be_valid
  end

end