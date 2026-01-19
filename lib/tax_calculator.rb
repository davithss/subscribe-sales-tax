# frozen_string_literal: true

# Stateless tax calculator that computes tax for a single item.
# Encapsulates tax rates and rounding logic.
class TaxCalculator
  BASIC_TAX_RATE = 0.10
  IMPORT_TAX_RATE = 0.05

  # Calculates the total tax amount for an item.
  # Tax is calculated per unit, rounded, then multiplied by quantity.
  # Returns the tax amount rounded up to the nearest 0.05, then rounded to 2 decimal places
  # to avoid floating-point precision issues.
  #
  # @param item [Item] The item to calculate tax for
  # @return [Float] The tax amount
  def self.calculate(item)
    tax_per_unit = 0.0

    # Apply basic sales tax (10%) unless item is tax exempt
    tax_per_unit += item.unit_price * BASIC_TAX_RATE unless item.tax_exempt

    # Apply import duty (5%) for all imported items
    tax_per_unit += item.unit_price * IMPORT_TAX_RATE if item.imported

    # Round per-unit tax, then multiply by quantity
    rounded_tax_per_unit = round_up_to_nearest_0_05(tax_per_unit)
    total_tax = rounded_tax_per_unit * item.quantity
    
    # Round to 2 decimal places to avoid floating-point precision issues
    (total_tax * 100).round / 100.0
  end

  # Rounds up to the nearest 0.05
  # Example: 1.01 -> 1.05, 1.05 -> 1.05, 1.06 -> 1.10
  #
  # @param amount [Float] The amount to round
  # @return [Float] The rounded amount
  def self.round_up_to_nearest_0_05(amount)
    (amount * 20).ceil / 20.0
  end
end
