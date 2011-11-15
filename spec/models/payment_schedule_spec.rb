require 'spec_helper'

describe PaymentSchedule do
  before (:each) do
    @attr = { :name => "Generic Payment Type", :deposit => 60.00, :final_payment => 150.00,
              :second_payment => 150.00, :total_payment => 360.00}
  end

  it "should create a new instance with valid attributes" do
    item = PaymentSchedule.create!(@attr)
    item.should be_valid
  end

  it "name should not be blank" do
    no_name = PaymentSchedule.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end

  it "name should be unique" do
    item1 = PaymentSchedule.create!(@attr)
    item2 = PaymentSchedule.new(@attr)
    item2.should_not be_valid
  end

  it "deposit should be a positive number" do
    item = PaymentSchedule.new(@attr.merge(:deposit => 0))
    item.should_not be_valid
  end

  it "total payment should be a positive number" do
    item = PaymentSchedule.new(@attr.merge(:total_payment => 0))
    item.should_not be_valid
  end

  it "final payment should be zero or a positive number" do
    item = PaymentSchedule.new(@attr.merge(:final_payment => -10))
    item.should_not be_valid
  end

  it "second payment should be zero or a positive number" do
    item = PaymentSchedule.new(@attr.merge(:second_payment => -10))
    item.should_not be_valid
  end

  it "total payment should equal deposit, second and final" do
    item = PaymentSchedule.new(@attr.merge(:second_payment => 0))
    item.should_not be_valid
  end
end