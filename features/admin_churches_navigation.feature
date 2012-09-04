Feature: churches navigation
  In order to manage church information
  As an admin user
  I want to be able to navigate to churches pages
  Scenario: Admin user
    Given a logged on "Admin"
    When I do nothing
    Then I see the "Dashboard" page
    And I see my name on the menu bar
  Scenario: Churches
    Given a logged on "Admin"
    When I do nothing
    Then I see a "Churches" menu item
    When I click on "Churches"
    Then I see the "Churches" page
    And I see a "New Church" button
    When I visit "Churches" and click on "New Church" button
    Then I see the "New Church" page

