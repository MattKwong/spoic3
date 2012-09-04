require 'factory_girl'

FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :username do |n|
    "SSPuser#{n}"
  end

  sequence :phone do |n|
    "#{n}#{n}#{n}#{n}#{n}#{n}#{n}#{n}#{n}#{n}"
  end
end

#Matt's factory
FactoryGirl.define do
  factory :admin_user do
    first_name "John"
    last_name "Doe"
    email FactoryGirl.generate :email
    confirmation_sent_at { 2.day.ago }
    confirmed_at { 1.day.ago }
    user_role_id { 1 }
    username FactoryGirl.generate :username
    password "foobar"
    password_confirmation "foobar"
    phone FactoryGirl.generate :phone
  end

  factory :user_role do
    id { 1 }
    name  "Admin"
  end

  #factory :user_role_liaison do
  #  id { 2 }
  #  name  "Liaison"
  #end
  #
  #factory :user_role_food_admin do
  #  id { 3 }
  #  name  "Food Admin"
  #end
  #
  #factory :user_role_construction_admin do
  #  id { 4 }
  #  name  "Construction Admin"
  #end
  #
  #factory :user_role_staff do
  #  id { 5 }
  #  name  "Staff"
  #end
end

#Rick's New Factories
#FactoryGirl.define do
#  factory :admin_user do
#    first_name 'Test'
#    last_name 'Admin'
#    user_role_id 1
#    email 'user@test.com'
#    password 'password'
#    confirmed_at Time.now
#  end

  #factory :liaison_user do
  #  first_name 'Test'
  #  last_name 'Liaison'
  #  user_role_id 1
  #  email 'liaison@test.com'
  #  password 'password'
  #  confirmed_at Time.now
  #end
#end

#FactoryGirl.define do
#  factory :admin_user do
#     email  "abc@abc.com"
#     first_name "Jane"
#     last_name  "Doe"
#    :password
     #phone  "1234567891"
     #user_role  6
     #username "JD"
     #site "Abc.com"
    #liaison_id nil
    #admin true
  #end
#end

#FactoryGirl.define do
#  factory :admin_user do
#    first_name 'Test'
#    last_name 'Admin'
#    email 'user@test.com'
#    password 'please'
#    confirmed_at Time.now
#
    #trait(:admin) {admin true}
  #end
  # Do Nothing
#end

#Factory.define :admin_user do |u|
#  u.first_name 'Test'
#  u.last_name 'Admin'
#  u.user_role 'Admin'
#  u.email 'user@test.com'
#  u.password 'please'
#  u.confirmed_at Time.now
#end