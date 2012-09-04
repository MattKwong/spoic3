Feature: register a group
  In order for groups to register for a session
  As a valid liaison for a church
  I want to liaison to be able to create a group registration and make a payment
  Scenario: Liaison reviews and updates group and liaison information
    Given a logged on liaison
    When I show the please_verify_information page
    Then I should see the page title "Registration Step 1"