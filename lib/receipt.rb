# frozen_string_literal: true

require_relative 'shopping_basket'
require_relative 'tax_calculator'

# Responsible for formatting receipt output.
# Contains no business logic, only presentation.
class Receipt
  def initialize(shopping_basket, tax_calculator: TaxCalculator)
    @shopping_basket = shopping_basket
    @tax_calculator = tax_calculator
  end

  def to_s
    lines = @shopping_basket.items.map do |item|
      item_total = item.total_price + @tax_calculator.calculate(item)
      "#{item.quantity} #{item.name}: #{format_price(item_total)}"
    end

    lines << "Sales Taxes: #{format_price(@shopping_basket.total_tax)}"
    lines << "Total: #{format_price(@shopping_basket.total_price)}"

    lines.join("\n")
  end

  private

  def format_price(amount)
    format('%.2f', amount)
  end
end
