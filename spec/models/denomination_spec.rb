require 'spec_helper'

describe Denomination do
  before (:each) do
    @attr = { :name => "Generic Denomination"}
  end

  it "should create a new instance with valid attributes" do
    Denomination.create!(@attr)
  end

  it "name should not be blank" do
    no_name = Denomination.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end

  it "name should be unique" do
    church1 = Denomination.create!(@attr)
    church2 = Denomination.new(@attr)
    church2.should_not be_valid
  end
end