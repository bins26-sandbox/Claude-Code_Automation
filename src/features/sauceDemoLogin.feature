Feature: SauceDemo login
    As a user of saucedemo.com
    I want to log in with valid credentials
    So that I can access the products inventory page

    Scenario: Successful login with standard_user
        Given I open the url "https://www.saucedemo.com/"
        And   I clear the inputfield "#user-name"
        When  I add "standard_user" to the inputfield "#user-name"
        And   I clear the inputfield "#password"
        And   I add "secret_sauce" to the inputfield "#password"
        And   I click on the button "#login-button"
        Then  I expect that the url is "https://www.saucedemo.com/inventory.html"
        And   I expect that element ".inventory_list" becomes displayed
        And   I expect that element ".title" becomes displayed
