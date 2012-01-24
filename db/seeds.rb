# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

if AdminUser.find_by_email("admin@sierraserviceproject.org")
  AdminUser.find_by_email("admin@sierraserviceproject.org").delete
end

AdminUser.create(:email => 'admin@sierraserviceproject.org', :password => 'ssp4all', :first_name => "Meghan",
    :last_name => "Osborn", :name => "Meghan Osborn", :user_role => "Admin", :confirmation_token => "oHS55xkkOpIFlt8nZVSnoc+ZkqGEV29Cp4zagy7ie+Q=",
    :confirmed_at => Time.now)

if AdminUser.find_by_email("director@sierraserviceproject.org")
  AdminUser.find_by_email("director@sierraserviceproject.org").delete
end

AdminUser.create(:email => 'director@sierraserviceproject.org', :password => 'norge1', :first_name => "Rick",
    :last_name => "Eaton", :name => "Rick Eaton", :user_role => "Admin", :confirmation_token => "oHS55xkkOpIFlt8nZVSnoc+ZkqGEV29Cp4zagy7ie+Q=",
    :confirmed_at => Time.now)