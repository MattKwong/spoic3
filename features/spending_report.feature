Feature: spending report
  In order to compare spending data in SM with spending data in QB
  As a valid admin
  I want to be able to create a spending report with start and stop dates which I specify
#  @javascript
  Scenario: Accessing the report page
    Given a logged on admin
    When I click on the spending report item on the Reports Menu
    Then I see the Spending Report page with start and stop dates equal to program start and stop dates
  Scenario: Showing the report
    Given I see the Spending Report page
    When I clink on the Show Report button
    Then I see the Spending Report table on the page