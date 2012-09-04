Feature: liaison navigation
  In order to manage liaison information
  As an admin user
  I want to be able to navigate to liaison pages
  Scenario: Liaisons
    Given a logged on "Liaison"
    When I do nothing
    Then I see a "Liaisons" menu item
    When I click on "Liaisons"
    Then I see the "Liaisons" page
    And I see a "New Liaison" button
    When I visit "Liaisons" and click on "New Liaison" button
    Then I see the "New Liaison" page