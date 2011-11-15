require 'spec_helper'

describe Period do
  before (:each) do
    @attr = { :name => "Period", :start_date => Date.today+1, :end_date => Date.today+3}
  end

  it "should create a new instance with valid attributes" do
    item = Period.create!(@attr)
    item.should be_valid
  end

  it "name should not be blank" do
    no_name = Period.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end

  it "start date should not be blank" do
    item = Period.new(@attr.merge(:start_date => ''))
    item.should_not be_valid
  end

  it "end date should not be blank" do
    item = Period.new(@attr.merge(:end_date => ''))
    item.should_not be_valid
  end

  it "start date cannot be in the past" do
    item = Period.new(@attr.merge(:start_date => Date.today-1))
    item.should_not be_valid
  end

  it "start date cannot be after end date" do
    item = Period.new(@attr.merge(:start_date => Date.today+4))
    item.should_not be_valid
  end

end