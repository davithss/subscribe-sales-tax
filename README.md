# Sales Tax Calculator

A command-line application that calculates sales tax and generates receipts for shopping baskets, implemented in pure Ruby following clean Object-Oriented Design principles.

## Requirements

- Ruby 3.x
- Bundler (for managing dependencies)
- RSpec (for running tests)

## Setup

Install dependencies:

```bash
bundle install
```

## How to Run

### Run the Application

```bash
ruby main.rb
```

This will process all three test cases and display the expected outputs.

### Run Tests

```bash
bundle exec rspec
```

Or simply:

```bash
rspec
```

Or run specific test files:

```bash
rspec spec/tax_calculator_spec.rb
rspec spec/shopping_basket_spec.rb
rspec spec/receipt_spec.rb
rspec spec/input_parser_spec.rb
```

## Project Structure

```
lib/
  item.rb              # Simple data class representing a purchasable item
  tax_calculator.rb    # Stateless tax calculation logic
  shopping_basket.rb   # Aggregates items and calculates totals
  receipt.rb           # Formats receipt output
  input_parser.rb      # Parses input lines into Item objects
spec/
  tax_calculator_spec.rb
  shopping_basket_spec.rb
  receipt_spec.rb
  input_parser_spec.rb
main.rb                # CLI entry point with test cases
README.md
```

## Design Decisions

### Object-Oriented Design

- **Item**: A simple data class with attributes only. No business logic, making it easy to test and reason about.
- **TaxCalculator**: Stateless class with class methods. Encapsulates all tax calculation rules and rounding logic in one place.
- **ShoppingBasket**: Uses composition to delegate tax calculation to `TaxCalculator`. This allows for easy testing via dependency injection.
- **Receipt**: Pure presentation logic. Separated from business logic to follow Single Responsibility Principle.

### Composition Over Inheritance

The solution uses composition throughout:
- `ShoppingBasket` composes `TaxCalculator` rather than inheriting from it
- `Receipt` composes `ShoppingBasket` and `TaxCalculator`
- No inheritance hierarchy for tax logic, as required

### Thread Safety

- No global mutable state
- No shared mutable class state
- All objects are stateless or contain only instance state
- `TaxCalculator` uses class methods (stateless)

### Tax Calculation Logic

- **Basic Sales Tax (10%)**: Applied to all items except books, food (chocolate), and medical products (pills)
- **Import Duty (5%)**: Applied to all imported items, regardless of tax-exempt status
- **Rounding**: Taxes are rounded up to the nearest 0.05 using the formula: `(amount * 20).ceil / 20.0`

### Input Parsing

The `InputParser` class:
- Detects imported items by the presence of the word "imported"
- Identifies tax-exempt items by keywords: "book", "chocolate", "pills"
- Handles the input format: `"quantity description at price"`

## Assumptions

1. **Tax-Exempt Categories**: Books, food (identified by "chocolate"), and medical products (identified by "pills") are tax-exempt. The parser uses keyword matching for simplicity.

2. **Import Detection**: Items containing the word "imported" in their description are considered imported.

3. **Price Formatting**: All prices are formatted to two decimal places in the output.

4. **Input Format**: Input lines follow the pattern: `"quantity description at price"`. Invalid lines are silently ignored.

5. **Tax Rounding**: The "round up to nearest 0.05" requirement is implemented using ceiling division, which ensures taxes are always rounded up (not to nearest).

## Why This Solution Avoids Over-Engineering

1. **No Frameworks**: Pure Ruby standard library only. No Rails, no complex abstractions.

2. **No Factories or Builders**: Items are created directly with `Item.new`. The `InputParser` is a simple utility, not a factory pattern.

3. **No DSLs**: Business logic is explicit and readable. No domain-specific languages or metaprogramming.

4. **No Unnecessary Patterns**: 
   - No Strategy pattern (tax rules are simple enough for conditional logic)
   - No Visitor pattern (not needed for this scope)
   - No Abstract Factory (only one type of calculator)

5. **Explicit Over Clever**: 
   - Tax rates are constants, not computed
   - Rounding logic is a simple mathematical formula
   - Class responsibilities are clear and minimal

6. **Testability Without Mocks**: The design allows for comprehensive testing without heavy mocking. `TaxCalculator` is easily testable in isolation, and `ShoppingBasket` can be tested with real `Item` objects.

7. **Minimal Dependencies**: Only RSpec for testing. No runtime dependencies.

The solution prioritizes clarity, maintainability, and correctness over demonstrating advanced patterns. A senior engineer can understand and modify any part of the codebase quickly.
