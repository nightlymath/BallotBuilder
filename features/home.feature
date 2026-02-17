Feature: Home page

  Scenario: Home page loads
    Given the development server is running on http://localhost:3000
    When the browser navigates to "/"
    Then the page loads and shows "Welcome to BallotBuilder" or the default application heading
