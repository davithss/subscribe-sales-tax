# frozen_string_literal: true

require_relative 'item'
require_relative 'tax_calculator'

# Aggregates items and calculates totals using TaxCalculator via composition.
class ShoppingBasket
  attr_reader :items

  def initialize(tax_calculator: TaxCalculator)
    @items = []
    @tax_calculator = tax_calculator
  end

  def add_item(item)
    @items << item
  end

  def total_tax
    @items.sum { |item| @tax_calculator.calculate(item) }
  end

  def total_price
    @items.sum(&:total_price) + total_tax
  end
end
