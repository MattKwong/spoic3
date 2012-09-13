require 'spec_helper'

describe SessionType do
  before (:each) do
    @attr = { :name => "A Session Type", :description => "Session Type Description"}
  end

  it "should create a new instance with valid attributes" do
    session = SessionType.create!(@attr)
    session.should be_valid
  end

  describe "session name tests" do

    it "name should not be blank" do
      no_name_session = SessionType.new(@attr.merge(:name => ''))
      no_name_session.should_not be_valid
    end

    it "name should be unique" do
      session1 = SessionType.create!(@attr)
      session2 = SessionType.new(@attr)
      session2.should_not be_valid
    end

  end

  describe "session description tests" do

    it "description should not be blank" do
      no_description_session = SessionType.new(@attr.merge(:description => ''))
      no_description_session.should_not be_valid
    end

  end


end