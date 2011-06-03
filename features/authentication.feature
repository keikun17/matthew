Feature: Authentication
  In order to access Matthew's functions
  As an administrator

  Scenario: When I am not logged in
    Given I am not authenticated

    Then I should not see "buddy@devex.com"
    And I should not see "Logout"

  Scenario: When I am logged in
    Given I have one admin "buddy@devex.com" with password "qwerty123"
    And I am on the home page
    Then I should see "Login"
    When I follow "Login"
    And I fill in "admin_email" with "buddy@devex.com"
    And I fill in "admin_password" with "qwerty123"
    And I press "Sign in"
    Then I should see "Signed in successfully"
    And I should see "buddy@devex.com"
    And I should see "Logout"
