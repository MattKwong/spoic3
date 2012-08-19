Given /^a logged on liaison$/ do
  @liaison_attr = {:admin => false, :user_role_id => UserRole.find_by_name("Liaison").id,
                   :email => "validliaison@example.com", :first_name => "Cindy", :last_name => "Liaison",
                   :username => "CindyLiaison1", :liaison_id => 1}
  valid_admin = AdminUser.new(@liaison_attr)
end

When /^I show the please_verify_information page$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see the page title "(.*?)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end