# frozen_string_literal: true

# Represents a purchasable item with its attributes.
# This is a simple data class with no business logic.
class Item
  attr_reader :name, :quantity, :unit_price, :imported, :tax_exempt

  def initialize(name:, quantity:, unit_price:, imported: false, tax_exempt: false)
    @name = name
    @quantity = quantity
    @unit_price = unit_price
    @imported = imported
    @tax_exempt = tax_exempt
  end

  def total_price
    quantity * unit_price
  end
end
