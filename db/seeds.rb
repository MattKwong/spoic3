# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#
#if AdminUser.find_by_email("admin@sierraserviceproject.org")
#  AdminUser.find_by_email("admin@sierraserviceproject.org").delete
#end
#
#AdminUser.create(:email => 'admin@sierraserviceproject.org', :password => 'ssp4all', :first_name => "Meghan",
#    :last_name => "Osborn", :name => "Meghan Osborn", :user_role => "Admin", :confirmation_token => "oHS55xkkOpIFlt8nZVSnoc+ZkqGEV29Cp4zagy7ie+Q=",
#    :confirmed_at => Time.now)
#
#if AdminUser.find_by_email("director@sierraserviceproject.org")
#  AdminUser.find_by_email("director@sierraserviceproject.org").delete
#end
#

if UserRole.find_by_name("Admin")
  UserRole.find_by_name("Admin").delete
end
UserRole.create(:name => 'Admin', :description => 'Admin user with full capability')

if UserRole.find_by_name("Liaison")
  UserRole.find_by_name("Liaison").delete
  end
UserRole.create(:name => 'Liaison', :description => 'Liaison user role')

if UserRole.find_by_name("Staff")
  UserRole.find_by_name("Staff").delete
  end
UserRole.create(:name => 'Staff', :description => 'Field staff, work limited to one site only')

if Site.find_by_name("Test Site 1")
  Site.find_by_name("Test Site 1").delete
  end
Site.create(:name => 'Test Site 1', :address1 => "100 Elm Street", :city => "Susanville", :state => "CA", :zip => "90000", :listing_priority => 10,
            :abbr => "T1", :active => true, :phone => "800-700-6000")

if Site.find_by_name("Test Site 2")
  Site.find_by_name("Test Site 2").delete
  end
Site.create(:name => 'Test Site 2', :address1 => "100 Reservation Way", :city => "McDermitt", :state => "NV", :zip => "80000", :listing_priority => 20,
            :abbr => "T2", :active => true, :phone => "800-700-6000")

['Site Director', 'Food', 'Construction', 'SLC'].each do |name|
  if JobType.find_by_name(name)
    JobType.find_by_name(name).delete
  end
  JobType.create(:name => name)
end


if Job.find_by_name('Site Director')
  Job.find_by_name('Site Director').delete
end
Job.create(:name => 'Site Director', :job_type_id => JobType.find_by_name('Site Director').id)

if Job.find_by_name('Spiritual Life Coordinator')
  Job.find_by_name('Spiritual Life Coordinator').delete
end
Job.create(:name => 'Spiritual Life Coordinator', :job_type_id => JobType.find_by_name('SLC').id)

if Job.find_by_name('Cook')
  Job.find_by_name('Cook').delete
end
Job.create(:name => 'Cook', :job_type_id => JobType.find_by_name('Food').id)

['Home Repair Coordinator', 'Construction Coordinator', 'Supply Coordinator'].each do |name|
  if Job.find_by_name(name)
    Job.find_by_name(name).delete
  end
  Job.create(:name => name, :job_type_id => JobType.find_by_name('Construction').id)
end


if ProgramType.find_by_name("Summer Domestic")
  ProgramType.find_by_name("Summer Domestic").delete
end
ProgramType.create(:name => 'Summer Domestic', :description => 'Standard summer domestic program', :position => 10)

[['Materials','Construction materials and consumable tools', 10], ['Food','Food and consumable kitchen items', 20],
['Worship & Study','Materials purchased for program activities', 30], ['Fuel','Fuel for all site vehicles', 40],
['Lodging','If necessary to and from site from Sacramento', 50], ['Meals', 'Staff meals to and from site as well as a few meals during summer - restaurant receipts', 60],
['Team Building','If necessary team activities to boost moral', 70], ['Office Supply', 'Toner, paper, copy keys, etc.', 80],
['Misc','Items that do not fit in other budget item types - be sure to put notes so Meghan can account for them appropriately', 90],
['Tools', 'Tools approved by Megan Taylor to purchase. Items that will become part of tool trailer inventory', 15]].each do |item|
  if BudgetItemType.find_by_name(item[0])
    BudgetItemType.find_by_name(item[0]).delete
  end
  BudgetItemType.create(:name => item[0], :description => item[1], :seq_number => item[2])
end

Program.delete_all
Program.create(:site_id => Site.find_by_name('Test Site 1').id, :program_type_id => ProgramType.find_by_name('Summer Domestic').id,
               :start_date => Date.strptime("06/01/2012", "%m/%d/%Y"),
               :end_date => Date.strptime("08/31/2012", "%m/%d/%Y"), :active => 't' )

LiaisonType.delete_all
LiaisonType.create(:name => "Both Junior and Senior High", :description => "Both junior and senior high groups")
LiaisonType.create(:name => "Senior High Only", :description => "Senior high only liaisons")

ChurchType.delete_all
ChurchType.create(:name => "Cal Pac UM Church")
ChurchType.create(:name => "Cal Nevada UM Church")

Church.delete_all
Church.create(:active => 't', :address1 => "100 Highway 99", :city => "Modesto", :state => "CA",
      :church_type_id => ChurchType.first.id, :email1 => "testchurch@church.com", :fax => '800-123-1234',
      :name => 'Modesto First UMC', :office_phone => "799-234-1888", :registered => 'n',
      :zip => "98750")

Church.create(:active => 't', :address1 => "100 Highway 99", :city => "Stockton", :state => "CA",
      :church_type_id => ChurchType.first.id, :email1 => "stocktonchurch@church.com", :fax => '800-123-1234',
      :name => 'Stockton First UMC', :office_phone => "799-234-1888", :registered => 'n',
      :zip => "98750")

Liaison.delete_all
Liaison.create(:address1 => "100 Elm Street", :city => "Sacramento", :state => "CA",
    :zip => "95608", :first_name => "Susan", :last_name => "Liaison", :name => "Susan Liaison",
    :title => "Youth Director", :cell_phone => "800-123-1234", :work_phone => "800-123-5667",
    :home_phone => "800-123-1234", :fax => "800-123-1234", :church_id => Church.first.id,
    :liaison_type_id => LiaisonType.find_by_name('Both Junior and Senior High').id,
    :email1 => "liaison@church.com")


