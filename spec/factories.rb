require 'factory_girl'

FactoryGirl.define do
  #factory :user_role do
  #  name 'Admin'
  #  description 'User with full administrative rights'
  #end

  factory :admin_user do
    first_name 'Test'
    last_name 'Admin'
    user_role_id 1
    email 'user@test.com'
    password 'password'
    confirmed_at Time.now
  end

  factory :liaison_user do
    first_name 'Test'
    last_name 'Liaison'
    user_role_id 1
    email 'liaison@test.com'
    password 'password'
    confirmed_at Time.now
  end
end