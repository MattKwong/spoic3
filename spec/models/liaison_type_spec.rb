require 'spec_helper'

describe LiaisonType do
  before (:each) do
    @attr = { :name => "Generic Type", :description => "Liaison Type Description"}
  end

  it "should create a new instance with valid attributes" do
    LiaisonType.create!(@attr)
  end

  it "name should not be blank" do
    no_name = LiaisonType.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end

  it "name should be unique" do
    church1 = LiaisonType.create!(@attr)
    church2 = LiaisonType.new(@attr)
    church2.should_not be_valid
  end

  it "description should not be blank" do
    church2 = LiaisonType.new(@attr.merge(:description => ""))
    church2.should_not be_valid
  end
end