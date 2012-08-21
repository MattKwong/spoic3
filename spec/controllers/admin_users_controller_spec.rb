require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!
#include ControllerMacros

describe AdminUsersController do
  render_views
  #login_admin

  #def login(user)
  #  post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
  #end

  #before (:each) do
    #@request.env["devise.mapping"] = Devise.mappings[:admin_user]
    #@test_user = FactoryGirl.build(:admin_user)
    #@user_attr = FactoryGirl.attributes_for(:admin_user)
    #@user = Factory(:admin_user)
    #user.create!(@user_attr)
    #sign_in @test_user
    #@ability = Ability.new(admin_user)
    #assign(:current_ability, @ability)
    #controller.stub(:current_user, admin_user)
    #view.stub(:current_user, admin_user)

  #end

  #def setup
  #  @request.env["devise.mapping"] = Devise.mappings[:admin]
  #  sign_in FactoryGirl.build(:admin)
  #end

  #describe "Regarding a test Admin account" do
  #
  #  it "should create an account" do
  #    get '/'
  #    response.should be_success
  #  end

    #it 'GET /registration/register' do
    #  post(:create)
    #  response.should be_success
    #end

  #end

  #describe "GET /users" do
  #  it "should be able to get" do
  #    clear_users_and_add_admin #does what it says...
  #    login(admin)
  #    get users_path
  #    response.status.should be(200)
  #  end
  #end

  #sign_out @test_user

  describe "the sign in process for an Admin", :type => :request do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      TestUser = FactoryGirl.create(:admin_user)
      #TestUser.save!
      #TestUser.confirm!
      #Capybara.reset_sessions!

      TestRole = FactoryGirl.create(:user_role)
    end

    #it 'GET /registration/register' do
    #  subject.create!(TestUser)
    #  response.should be_success
    #end

    it "can access sign in page by direct link" do
      get '/admin_users/sign_in'
      response.should be_success
    end

    it "can access sign in page by clicking the link" do
      visit '/'
      click_link('Please sign in')
      #response.should be_success
    end

    it "invalid sign in test (empty email)" do#, :js => :true do
      visit '/admin_users/sign_in'
      fill_in 'Email', :with => ''
      fill_in 'Password', :with => 'foo'
      click_button('Sign in')
      #save_and_open_page
      page.should have_content("Invalid email or password.")
    end

    it "invalid sign in test (empty password)" do#, :js => :true do
      visit '/admin_users/sign_in'
      fill_in 'Email', :with => TestUser.email
      fill_in 'Password', :with => ''
      click_button('Sign in')
      #save_and_open_page
      page.should have_content("Invalid email or password.")
    end

    it "invalid sign in test (empty email and password)" do#, :js => :true do
      visit '/admin_users/sign_in'
      fill_in 'Email', :with => ''
      fill_in 'Password', :with => ''
      click_button('Sign in')
      #save_and_open_page
      page.should have_content("Invalid email or password.")
    end

    it "valid sign in test" , :js => :true do
      visit '/'
      click_link 'Please sign in'
      fill_in 'Email', :with => TestUser.email
      fill_in 'Password', :with => TestUser.password
      #save_and_open_page
      click_button('Sign in')
      #current_path.should == '/admin'
      #page.should have_content("Signed in successfully.")
      current_path.should == '/admin' and page.should have_content("Signed in successfully.")
    end

    it "valid sign out test" do#, :js => :true do
      visit '/'
      click_link 'Please sign in'
      fill_in 'Email', :with => TestUser.email
      fill_in 'Password', :with => TestUser.password
      #save_and_open_page
      click_button('Sign in')
      click_link('Logout')
      #current_path.should == '/'
      #page.should have_content("Signed out successfully.")
      current_path.should == '/' and page.should have_content("Signed out successfully.")
    end

    describe "once logged in as Admin" do

      describe "from the dashboard page" do

        it "all navigation links are accessible" do#, :js => :true do
          visit '/'
          click_link 'Please sign in'
          fill_in 'Email', :with => TestUser.email
          fill_in 'Password', :with => TestUser.password
          #save_and_open_page
          click_button('Sign in')

          # Main Navigation Buttons
          click_link 'Churches'
          click_link 'Liaisons'
          click_link 'Purchases'
          click_link 'Budgets'
          click_link 'Configuration'
          click_link 'Groups'
          click_link 'Items'
          click_link 'Projects'
          click_link 'Users and Logs'

          # Budgets Drop Down Menu
          click_link 'Budget Item Types'
          click_link 'Budget Items'

          # Configuration Drop Down Menu
          click_link 'Adjustment Codes'
          click_link 'Checklist Items'
          click_link 'Church Types'
          click_link 'Conferences'
          click_link 'Denominations'
          click_link 'Downloadable Documents'
          click_link 'Job Types'
          click_link 'Jobs'
          click_link 'Liaison Types'
          click_link 'Organizations'
          click_link 'Payment Schedules'
          click_link 'Periods'
          click_link 'Program Types'
          click_link 'Programs'
          click_link 'Reminders'
          click_link 'Session Types'
          click_link 'Sessions'
          click_link 'Sites'
          click_link 'Special Needs'
          click_link 'User Roles'


          # Groups Drop Down Menu
          click_link 'History'
          click_link 'Payments'
          click_link 'Scheduled Groups'
          click_link 'Requests'
          click_link 'Roster Items'

          # Items Drop Down Menu
          click_link 'Item Categories'
          click_link 'Item Types'
          click_link 'Items'

          # Projects Drop Down Menu
          click_link 'Project Categories'
          click_link 'Project Subtypes'
          click_link 'Project Types'
          click_link 'Projects'
          click_link 'Standard Items'

          # Users and Logs Drop Down Menu
          click_link 'Activities'
          click_link 'Admin Users'
          click_link 'Program Users'

          #response.should be_success
          #current_path.should == '/admin'
          #page.should have_content("Signed in successfully.")
          #current_path.should == '/admin' and page.should have_content("Signed in successfully.")
        end

      end

      describe "from the SSP information center/manager page" do

      #  Doesn't work because links are unlabeled
      #  it "all navigation links are accessible" do
      #
      #    visit '/'
      #    click_link 'Please sign in'
      #    fill_in 'Email', :with => TestUser.email
      #    fill_in 'Password', :with => TestUser.password
          #save_and_open_page
          #click_button('Sign in')
          #
          # Main Navigation Buttons
          #click_link 'Home'
          #click_link 'Group Manager'
          #click_link 'Reports'
          #click_link 'Budgets'
          #click_link 'Admin Center'
          #click_link 'SiteManager'
          #click_link 'Help'

          # Group Manager Drop Down Menu
          #click_link 'Register a group'
          #click_link 'Schedule a group'
          #click_link 'Invoice report'
          #click_link 'Show the schedule - scheduled summer domestic'
          #click_link 'Show the schedule - unscheduled summer domestic'
          #click_link 'Reset user password'

          # Reports Drop Down Menu
          #click_link 'Invoice report'
          #click_link 'Scheduled Liaisons: Web page'
          #click_link 'Scheduled Liaisons: CSV'
          #click_link 'All Churches and Liaisons: CSV'
          #click_link 'Show the schedule - scheduled summer domestic'
          #click_link 'Show t-shirt order report'
          #
          # Budgets Drop Down Menu
          #click_link 'Budget Summary Reports'
          #click_link 'Add, Update or Delete Line Items'
          #click_link 'Maintain Line Item Types'
          #
          # Admin Center Drop Down Menu
          #click_link 'Churches'
          #click_link 'Liaisons'
          #click_link 'Purchases'
          #click_link 'Admin Center'
          #
          # SiteManager Drop Down Menu
          #click_link 'All Sites'
          #click_link 'Vendors'
          #click_link 'Items'
          #click_link 'Purchases'
          #click_link 'Reports'
          #click_link 'Projects'
          #click_link 'Food Inventories'

        #end

      end

    end

  end



end
