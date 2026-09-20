Feature: SauceDemo product sorting
    As a logged in user of saucedemo.com
    I want to sort the products
    So that I can verify the product list orders correctly

    Background:
        Given I open the url "https://www.saucedemo.com/"
        And   I clear the inputfield "#user-name"
        And   I clear the inputfield "#password"

    Scenario Outline: Sort products by <sort_option> and verify the first product
        When  I add "<username>" to the inputfield "#user-name"
        And   I add "<password>" to the inputfield "#password"
        And   I click on the button "#login-button"
        And   I expect that element ".inventory_list" becomes displayed
        And   I select the option with the text "<sort_option>" for element ".product_sort_container"
        Then  I expect that element ".inventory_item_name" matches the text "<first_product>"

        Examples:
            | username      | password     | sort_option         | first_product                     |
            | standard_user | secret_sauce | Name (A to Z)       | Sauce Labs Backpack               |
            | standard_user | secret_sauce | Name (Z to A)       | Test.allTheThings() T-Shirt (Red) |
            | standard_user | secret_sauce | Price (low to high) | Sauce Labs Onesie                 |
            | standard_user | secret_sauce | Price (high to low) | Sauce Labs Fleece Jacket          |
