require 'spec_helper'

describe PaymentSchedule do
  before (:each) do
    @attr = { :name => "Generic Payment Type", :deposit => 60.00, :final_payment => 150.00,
              :second_payment => 150.00, :total_payment => 360.00,
              :second_payment_date => '2012/01/01', :final_payment_date => '2012/03/30'}
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

  it "should accept a nil second payment date" do
    item = PaymentSchedule.new(@attr.merge(:second_payment_date => nil))
    item.should be_valid
  end

  it "should accept a valid second payment date" do
    item = PaymentSchedule.new(@attr.merge(:second_payment_date => '2012/01/01'))
    item.should be_valid
  end

  it "should reject an invalid second payment date" do
    item = PaymentSchedule.new(@attr.merge(:second_payment_date => '2011/03/35'))
    item.should_not be_valid
  end

  it "should accept a nil final payment date" do
    item = PaymentSchedule.new(@attr.merge(:final_payment_date => nil))
    item.should be_valid
  end

  it "should accept a valid final payment date" do
    item = PaymentSchedule.new(@attr.merge(:final_payment_date => '2012/09/01'))
    item.should be_valid
  end

  it "should reject an invalid final date" do
    item = PaymentSchedule.new(@attr.merge(:final_payment_date => '2011/13/30'))
    item.should_not be_valid
  end

  it "second payment date should be a date if second payment is not zero" do
    item = PaymentSchedule.new(@attr.merge(:second_payment => 100,
                                           :second_payment_date => nil))
    item.should_not be_valid
  end

  it "final payment date should be a valid date if final payment is not zero" do
    item = PaymentSchedule.new(@attr.merge(:final_payment => 100,
                                           :final_payment_date => nil))
    item.should_not be_valid
  end

  it "the second payment date should be before the final payment date" do
    item = PaymentSchedule.new(@attr.merge(:second_payment_date => '02/01/2012',
                                           :final_payment_date => '01/01/2012'))
    item.should_not be_valid
  end

  it "total payment should equal deposit, second and final" do
    item = PaymentSchedule.new(@attr.merge(:second_payment => 10.00))
    item.should_not be_valid
  end
end