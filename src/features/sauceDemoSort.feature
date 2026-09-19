Feature: SauceDemo product sorting
    As a logged in user of saucedemo.com
    I want to sort the products by name ascending
    So that I can verify the product list orders correctly

    Scenario: Sort products by Name (A to Z) and verify the first product
        Given I open the url "https://www.saucedemo.com/"
        And   I clear the inputfield "#user-name"
        When  I add "standard_user" to the inputfield "#user-name"
        And   I clear the inputfield "#password"
        And   I add "secret_sauce" to the inputfield "#password"
        And   I click on the button "#login-button"
        And   I expect that element ".inventory_list" becomes displayed
        And   I select the option with the text "Name (A to Z)" for element ".product_sort_container"
        Then  I expect that element ".inventory_item_name" matches the text "Sauce Labs Backpack"
