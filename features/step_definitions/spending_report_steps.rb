include Devise::TestHelpers

Given /^a logged on admin$/ do

    @request.env["devise.mapping"] = Devise.mappings[:admin_user]
    current_admin_user = FactoryGirl.create(:admin_user)
    current_admin_user.user_role.name = "Admin"
    current_admin_user.confirm!
    sign_in current_admin_user

end

When /^I click on the spending report item on the Reports Menu$/ do

  email = current_admin_user.email
  password = current_admin_user.password

  #password = 'ssp4all'
  #user_role_id = UserRole.find_by_name('Admin').id
  #AdminUser.new(:email => email, :password => password, :password_confirmation => password,
  #    :user_role_id => user_role_id, :last_name => 'Admin', :first_name => "Test", :admin => true,
  #    :name => "Test Admin").save!

  visit root_path
  click_link 'Please sign in.'
  fill_in "Email", :with => email
  fill_in "Password", :with => password
  check 'Remember me'
  click_button 'Sign in'
  save_and_open_page
  click_link 'Reports'
  click_link 'Spending Report'

end


Then /^I see the Spending Report page with start and stop dates equal to program start and stop dates$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I click on the Show Report button$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I see the Spending Report table on the page$/ do
  pending # express the regexp above with the code you wish you had
end
