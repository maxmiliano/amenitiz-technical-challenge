# Solution to Amenitiz Technical Challenge

This project is a command-line application developed as a solution to the Amenitiz technical challenge. It simulates a cash register that allows adding products to a cart and computes the total price, applying specific discounts based on predefined rules.

Original problem instructions [here](amenitiz-technical-challenge.md).

## Stack

- Ruby 3.2.2

## Key Decisions

- **Pure Ruby Application**: Chosen to avoid unnecessary complexity. Given the lack of requirements for persistence or a web interface, frameworks like Rails were deemed unnecessary.
- **Test-Driven Development (TDD)**: Employed to guide the development process, ensuring reliability and maintainability of the code from the outset. RSpec was chosen as the testing framework for its readability and flexibility.
- **Code Organization**: Follows the standard Ruby project structure for ease of extension and maintenance. Efforts were made to ensure that models and the overall codebase remain straightforward yet maintainable.
- **Command-Line Interface (CLI)**: The application was designed for command-line use, in line with the challenge's recommendations. This choice supports simplicity and direct interaction.
- **Testing Approach**: Although testing private methods is generally not recommended, this approach was chosen to test the `CashRegisterApp`, which is the CLI application, to ensure thorough coverage without introducing external dependencies for CLI interaction testing. This decision was made to maintain project simplicity and focus on internal logic validation.
- **Offer Rules**: The offer rules were implemented as a separate class to encapsulate the logic and allow for easy extension and modification. Decided to use the concrete rules as inner classes for simplicity.
  - **Volume Discount**: Implemented as a simple rule that checks the quantity of a specific product in the cart and applies a discount if the quantity meets the required threshold. It applies to the _Buy One Get One Free_ for the Green Tea and could also be used in a future scenario like _Buy 3 get 2 free_.
  - **Bulk QuantityThresholdDiscount**: Rule that checks the quantity of a specific product in the cart and applies a discount if the quantity meets the required threshold. It applies to the Strawberries (buy 3 or more, pay 4.50€ each) and to Coffee (buy 3 ore more, pay 2/3 of original each).
## How to run

Ensure Ruby 3.2.2 (or greater) is installed on your system. Then, follow these steps:

1. Clone the repository to your local machine.
2. Navigate to the root folder of the project.
3. Run `bundle install` to install required gems.
4. Start the application with `ruby lib/cash_register_app.rb start`.
5. Follow the on-screen instructions to interact with the cash register:
   - Enter a product code to add the corresponding product to the cart. (e.g., `GR1`, `SR1`, `CF1`)
   - Submit an empty line to calculate and display the total price, concluding the process.


## Hot to test
- Run `bundle exec rspec` in the root folder

## Future Improvements
- **CLI Interaction Testing**: Consider adding a library to test CLI interactions, such as `tty-prompt`, to ensure a more robust testing approach, avoid testing private methods, and don't leak log messages into the test output.
- **Logging**: Introduce logging to capture interactions and errors for better debugging and monitoring.
- **Usability Enhancements**: Add more user-friendly prompts and error messages to improve the user experience. Also add a way to list and search for products. Show the current cart contents and subtotal.
- **Performance Optimization**: Optimize the application for large product lists and cart sizes, ensuring efficient processing and response times.
- **Product Management**: Implement a way to add, remove, and update products and their prices, allowing for easy maintenance and extension of the product list. It could be through adding persissence or a way to load products from a CSV file, for instance.
