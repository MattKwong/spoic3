require 'spec_helper'

describe AdminUser do
  before (:each) do
    @attr = { :email => "validadmin@example.com", :first_name => "Test", :last_name => "Admin",
              :user_role_id => UserRole.find_by_name("Admin").id, :username => "JSmith1"  }
    @staff_attr = {:admin => false, :user_role_id => UserRole.find_by_name("Staff").id,
              :email => "validstaff@example.com", :first_name => "Joe", :last_name => "Staffer",
              :username => "JoStaffer1", :site_id => Site.find_by_name('Test Site 1').id }
    @liaison_attr = {:admin => false, :user_role_id => UserRole.find_by_name("Liaison").id,
              :email => "validliaison@example.com", :first_name => "Cindy", :last_name => "Liaison",
              :username => "CindyLiaison1", :liaison_id => 1}
  end

  describe "Valid entries" do
    it "should create a valid admin entry" do
      valid_admin = AdminUser.new(@attr)
      valid_admin.should be_valid
    end
    it "should create a valid liaison entry" do
      valid_liaison = AdminUser.new(@liaison_attr)
      valid_liaison.should be_valid
    end
    it "should create a valid staff entry" do
      valid_staff = AdminUser.new(@staff_attr)
      valid_staff.should be_valid
    end
  end

  describe "common to all user types" do
    it "should require an email" do
      no_email = AdminUser.new(@attr.merge(:email => ""))
      no_email.should_not be_valid
    end

    it "should reject an invalid email" do
      bad_email = AdminUser.new(@attr.merge(:email => "info@example"))
      bad_email.should_not be_valid
    end

    it "should reject a duplicate email" do
      good_email = AdminUser.new(@attr)
      good_email.save
      dup_email = AdminUser.new(@attr.merge(:first_name => "Duplicate", :last_name => "Email"))
      dup_email.should_not be_valid
    end

    it "should require a first name" do
      no_first = AdminUser.new(@attr.merge(:first_name => ""))
      no_first.should_not be_valid
    end
    it "should require a last name" do
      no_last = AdminUser.new(@attr.merge(:last_name => ""))
      no_last.should_not be_valid
    end
    it "should require a a valid phone number" do
      no_last = AdminUser.new(@attr.merge(:phone => "x123"))
      no_last.should_not be_valid
    end
  end

  describe "staff user tests" do
    it "should require a site id" do
      no_site = AdminUser.new(@attr.merge(:admin => false, :user_role_id => UserRole.find_by_name("Staff").id, :site_id => ""))
      no_site.should_not be_valid
    end
    it "should require a nonnegative integer site id" do
      no_site = AdminUser.new(@attr.merge(:admin => false, :user_role_id => UserRole.find_by_name("Staff").id, :site_id => 0))
      no_site.should_not be_valid
    end
    it "should require a site id that points to a valid site" do
      #this assumes that we will not ever have an id of 99 for a site in the test database
      bad_site = AdminUser.new(@attr.merge(:admin => false, :user_role_id => UserRole.find_by_name("Staff").id, :site_id => 99))
      bad_site.should_not be_valid
    end
  end
  describe "scope tests" do
    before :each do
      AdminUser.create!(@attr)
      AdminUser.create!(@liaison_attr)
      AdminUser.create!(@staff_attr)
    end
    it "should return the correct number of AdminUser entries " do
      AdminUser.all.count.should == 3
    end
    it "should return the correct number of liaison entries" do
      AdminUser.liaison.count.should == 1
    end
    it "should return the correct number of admin entries" do
      AdminUser.admin.count.should == 1
    end
    it "should return the correct number of staff entries" do
      AdminUser.staff.count.should == 1
    end
    it "should return the correct number of non-admin entries" do
      AdminUser.not_admin.count.should == 2
    end
  end

  describe "program user tests" do
    it "admin user should have no program user" do
      no_prog = AdminUser.new(@attr)
      no_prog.program_user.should == nil
    end
    it "admin user program id should return zero" do
      no_prog = AdminUser.new(@attr)
      no_prog.program_id.should == 0
    end

    describe "staff admin user tests" do
      it "staff admin user program id should return 1" do
        prog = AdminUser.create!(@staff_attr)
        ProgramUser.create!(:program_id => 1, :user_id => prog.id, :job_id => 1 )
        prog.program_id.should == 1
      end
      it "staff user should return a job name" do
        any_job = Job.first
        prog = AdminUser.create!(@staff_attr)
        ProgramUser.create!(:program_id => 1, :user_id => prog.id, :job_id => any_job.id )
        prog.job_name.should == any_job.name
      end
      it "user of site director should respond to sd?" do
        sd_job = Job.find_by_name('Site Director')
        prog = AdminUser.create!(@staff_attr)
        ProgramUser.create!(:program_id => 1, :user_id => prog.id, :job_id => sd_job.id )
        prog.should be_sd
      end
      it "user of HRC should respond to construction?" do
        hrc_job = Job.find_by_name('Home Repair Coordinator')
        prog = AdminUser.create!(@staff_attr)
        ProgramUser.create!(:program_id => 1, :user_id => prog.id, :job_id => hrc_job.id )
        prog.should be_construction
      end
      it "user of supply coordinator should respond to construction?" do
        supply_job = Job.find_by_name('Supply Coordinator')
        prog = AdminUser.create!(@staff_attr)
        ProgramUser.create!(:program_id => 1, :user_id => prog.id, :job_id => supply_job.id )
        prog.should be_construction
      end
      it "user of construction coordinator should respond to construction?" do
        construction_job = Job.find_by_name('Construction Coordinator')
        prog = AdminUser.create!(@staff_attr)
        ProgramUser.create!(:program_id => 1, :user_id => prog.id, :job_id => construction_job.id )
        prog.should be_construction
      end
      it "user of SLC should respond to slc?" do
        slc_job = Job.find_by_name('Spiritual Life Coordinator')
        prog = AdminUser.create!(@staff_attr)
        ProgramUser.create!(:program_id => 1, :user_id => prog.id, :job_id => slc_job.id )
        prog.should be_slc
      end
    end
  end

end

