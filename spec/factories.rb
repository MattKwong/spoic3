require 'factory_girl'

Factory.define :admin_user do |u|
  u.first_name 'Test'
  u.last_name 'Admin'
  u.user_role 'Admin'
  u.email 'user@test.com'
  u.password 'please'
  u.confirmed_at Time.now
end