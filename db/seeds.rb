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
