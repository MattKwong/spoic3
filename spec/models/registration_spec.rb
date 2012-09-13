require 'spec_helper'

describe "Registration" do
    # Old, all attributes
    #before (:each) do
    #  @attr = { :name => "Group Name", :request1 => 1, :request2 => 2, :request3 => 3,
    #              :request4 => 4, :request5 => 5, :request6 => 6, :request7 => 7,
    #              :request8 => 8, :request9 => 9, :request10 => 10,
    #              :requested_counselors => 2, :requested_youth => 10,
    #              :amount_due => 1000.00, :amount_paid => 200.00, :payment_method => "Check",
    #              :scheduled => false}
    #end

    # Just the required attributes
    before (:each) do
      @attr = { :name => "Group Name", :requested_youth => 10, :requested_counselors => 2 }
    end

    it "should create an instance given valid attributes" do
      item = Registration.new(@attr)
      item.should be_valid
    end

    describe "name tests" do

      it "should require a name" do
        item = Registration.new(@attr.merge(:name => ""))
        item.should_not be_valid
      end

    end

    describe "requested_youth tests" do

      it "should be an integer" do
        item = Registration.new(@attr.merge(:requested_youth => "one"))
        item.should_not be_valid
      end

      it "should not be a float" do
        item = Registration.new(@attr.merge(:requested_youth => 1.1))
        item.should_not be_valid
      end

      it "should be >= 1" do
        item = Registration.new(@attr.merge(:requested_youth => 0))
        item.should_not be_valid
      end

    end

    describe "requested_counselors tests" do

      it "should be an integer" do
        item = Registration.new(@attr.merge(:requested_counselors => "one"))
        item.should_not be_valid
      end

      it "should not be a float" do
        item = Registration.new(@attr.merge(:requested_counselors => 1.1))
        item.should_not be_valid
      end

      it "should be >= 1" do
        item = Registration.new(@attr.merge(:requested_counselors => 0))
        item.should_not be_valid
      end

    end

    describe "request priority logic tests" do

      describe "step 2 tests" do

        it "should require a request1 if in step 2" do
          item = Registration.new(@attr.merge(:request1 => nil, :registration_step => 'Step 2' ))
          item.should_not be_valid
        end

        it "should require a request1 if in step 2 (test 2)" do
          item = Registration.new(@attr.merge(:request1 => 1, :registration_step => 'Step 2' ))
          item.should be_valid
        end

        describe "request1 tests" do

          it "should be an integer" do
            item = Registration.new(@attr.merge(:request1 => "x", :registration_step => 'Step 2' ))
            item.should_not be_valid
          end

          it "should not be a float" do
            item = Registration.new(@attr.merge(:request1 => 1.1, :registration_step => 'Step 2' ))
            item.should_not be_valid
          end

          it "should be >= 1" do
            item = Registration.new(@attr.merge(:request1 => 1, :registration_step => 'Step 2' ))
            item.should be_valid
          end

        end

      end

      # I don't know how to test this section of the registration logic
      describe "Tests dealing with request sequence (DON'T WORK)" do
        it "should require that requests be in sequence" do
          item = Registration.new(@attr.merge(:request1 => 1, :registration_step => 'Step 2' ))
          item = Registration.new(@attr.merge(:request3 => 3, :registration_step => 'Step 2' ))
          item.should_not be_valid
        end

        it "should require that there be no duplicate requests" do
          item = Registration.new(@attr.merge(:request4 => 7))
          item.should_not be_valid
        end

        it "should treat 0 the same as nil" do
          item = Registration.new(@attr.merge(:request9 => 0, :request10 => 0))
          item.should be_valid
        end
      end

    end

  end

