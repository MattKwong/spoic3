require 'factory_girl'

FactoryGirl.define do

  factory :admin_user do
    first_name 'Test'
    last_name 'Admin'
    user_role_id UserRole.find_by_name("Admin").id
    email 'user@test.com'
    password 'password'
    confirmed_at Time.now
  end

  #factory :liaison do
  #  address "100 Elm Street"
  #  city "Sacramento"
  #  state "CA"
  #  zip "95608"
  #  first_name "Susan"
  #  last_name "Liaison"
  #  name "Susan Liaison"
  #  title "Youth Director"
  #  cell_phone "800-123-1234"
  #  work_phone "800-123-5667"
  #  liaison_type_id 1
  #
  #end

  factory :liaison_user, class: AdminUser do
    first_name 'Susan'
    last_name 'Liaison'
    user_role_id UserRole.find_by_name("Liaison").id
    liaison_id Liaison.first.id
    email 'liaison@test.com'
    password 'password'
    confirmed_at Time.now
  end
end