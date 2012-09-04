include Devise::TestHelpers

Given /^a logged on "(.*?)"$/ do |arg1|
  if @current_admin_user
    visit root_path
    click_button "Sign Out"
  end
  @current_admin_user = FactoryGirl.create("#{arg1.downcase.to_sym}_user")
  @current_admin_user.confirm!
  FactoryGirl.create(:user_role_admin)
  FactoryGirl.create(:user_role_liaison)
  FactoryGirl.create(:user_role_food_admin)
  FactoryGirl.create(:user_role_construction_admin)
  FactoryGirl.create(:user_role_staff)
  @email = @current_admin_user.email
  @password = @current_admin_user.password
  visit root_path
  click_link 'Please sign in.'
  fill_in "Email", :with => @email
  fill_in "Password", :with => @password
  check 'Remember me'
  click_button 'Sign in'

end

Given /^a valid liaison logon$/ do

  @current_admin_user = FactoryGirl.create(:liaison_user)
  @current_admin_user.confirm!
  @email = @current_admin_user.email
  @password = @current_admin_user.password
end

When /^I log on$/ do
  logon
end

Then /^I see a personalized welcome message$/ do
  find("#page_title").should have_content("MySSP Information Portal. Welcome, #{@current_admin_user.first_name}!")
end

def logon
  visit root_path
  click_link 'Please sign in.'
  fill_in "Email", :with => @email
  fill_in "Password", :with => @password
  check 'Remember me'
  click_button 'Sign in'
end