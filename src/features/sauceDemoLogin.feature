Feature: SauceDemo login
    As a user of saucedemo.com
    I want to log in with valid credentials
    So that I can access the products inventory page

    Background:
        Given I open the url "https://www.saucedemo.com/"
        And   I clear the inputfield "#user-name"
        And   I clear the inputfield "#password"

    Scenario Outline: Successful login as <username>
        When  I add "<username>" to the inputfield "#user-name"
        And   I add "<password>" to the inputfield "#password"
        And   I click on the button "#login-button"
        Then  I expect that the url is "<landing_url>"
        And   I expect that element ".inventory_list" becomes displayed
        And   I expect that element ".title" becomes displayed

        Examples:
            | username      | password     | landing_url                              |
            | standard_user | secret_sauce | https://www.saucedemo.com/inventory.html |
            | problem_user  | secret_sauce | https://www.saucedemo.com/inventory.html |
            | visual_user   | secret_sauce | https://www.saucedemo.com/inventory.html |
