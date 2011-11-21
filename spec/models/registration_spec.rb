require 'spec_helper'

describe "Registration" do
  describe "Unscheduled registration" do

    before (:each) do
      @attr = { :name => "Group Name", :request1 => 1, :request2 => 2, :request3 => 3,
                  :request4 => 4, :request5 => 5, :request6 => 6, :request7 => 7,
                  :request8 => 8, :request9 => 9, :request10 => 10,
                  :requested_counselors => 2, :requested_youth => 10,
                  :amount_due => 1000.00, :amount_paid => 200.00, :payment_method => "Check",
                  :scheduled => false}
    end

    it "should create an instance given valid attributes" do
      item = Registration.new(@attr)
      item.should be_valid
    end

    describe "basic tests" do
      it "should require a name" do
        item = Registration.new(@attr.merge(:name => ""))
        item.should_not be_valid
      end

      it "should require proper requested_youth integer" do
        item = Registration.new(@attr.merge(:requested_youth => 1.1))
        item.should_not be_valid
      end

      it "should require proper requested_counselors integer" do
        item = Registration.new(@attr.merge(:requested_counselors => 1.1))
        item.should_not be_valid
      end
    end

    describe "request priority logic tests" do
      it "should require a request1" do
        item = Registration.new(@attr.merge(:request1 => nil))
        item.should_not be_valid
      end

      it "should require that requests be in sequence" do
        item = Registration.new(@attr.merge(:request5 => 2))
        item.should_not be_valid
      end

      it "should require that there be no duplicate requests" do
        item = Registration.new(@attr.merge(:request4 => 7))
        item.should_not be_valid
      end
    end
  end
  describe "Scheduled registration" do
#:TODO Strange failures here..work when I comment and uncomment th numericality edits..
# appear connected to the before_save call also
      before (:each) do
        @attr = { :name => "Group Name", :request1 => 1, :request2 => 2, :request3 => 3,
                    :request4 => 4, :request5 => 5, :request6 => 6, :request7 => 7,
                    :request8 => 8, :request9 => 9, :request10 => 10,
                    :requested_counselors => 2, :requested_youth => 10,
                    :amount_due => 1000.00, :amount_paid => 200.00, :payment_method => "Check",
                    :scheduled => true, :scheduled_priority => 2, :scheduled_session => 2,
                    :current_youth => 10, :current_adults => 2, :current_total => 12 }
      end

    it "should create an instance with valid attributes" do
      item = Registration.new(@attr)
      item.should be_valid
    end

    it "should reject a priority greater than 10" do
      item = Registration.new(@attr.merge(:scheduled_priority => 12))
      item.should_not be_valid
    end

    it "should reject a priority less than 0" do
      item = Registration.new(@attr.merge(:scheduled_priority => -1))
      item.should_not be_valid
    end

    it "should reject an invalid scheduled session" do
      item = Registration.new(@attr.merge(:scheduled_session => nil))
      item.should_not be_valid
    end

    it "should require a non-zero current youth value" do
      item = Registration.new(@attr.merge(:current_youth => 0))
      item.should_not be_valid
    end

    it "should require a numeric counselor value, but allow zero" do
      item = Registration.new(@attr.merge(:current_counselors => -1))
      item.should_not be_valid
    end

    it "should require that current total equal current counselor + youth" do
      item = Registration.new(@attr.merge(:current_total => 12))
      item.should be_valid
    end
  end
end