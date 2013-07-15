Feature: API Http Status Code Raise Feature

  Background:
    Given that I have a valid API key
      And the default test dataset is loaded

  Scenario: Successful Request
    When I item-search with a raise parameter of "200"
    Then I should get http status code "200"
  
  Scenario: Bad Request Syntax
    When I item-search with a raise parameter of "400"
    Then I should get http status code "400"

  Scenario: Empty/Invalid/Disabled Access Key
    When I item-search with a raise parameter of "401"
    Then I should get http status code "401"

  Scenario: Resource Not Found
    When I item-search with a raise parameter of "404"
    Then I should get http status code "404"

  Scenario: Not Acceptable
    When I item-search with a raise parameter of "406"
    Then I should get http status code "406"

  Scenario: Too Many Requests
    When I item-search with a raise parameter of "429"
    Then I should get http status code "429"

  Scenario: Internal Server Error
    When I item-search with a raise parameter of "500"
    Then I should get http status code "500"

  Scenario: Service Unavailable
    When I item-search with a raise parameter of "503"
    Then I should get http status code "503"
