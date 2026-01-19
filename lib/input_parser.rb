# frozen_string_literal: true

require_relative 'item'

# Parses input lines into Item objects.
# Detects imported items and tax-exempt categories.
class InputParser
  TAX_EXEMPT_KEYWORDS = %w[book chocolate pills].freeze

  def self.parse_line(line)
    # Pattern: "quantity description at price"
    # Example: "2 book at 12.49"
    match = line.match(/\A(\d+)\s+(.+?)\s+at\s+([\d.]+)\z/)
    return nil unless match

    quantity = match[1].to_i
    description = match[2].strip
    unit_price = match[3].to_f

    imported = description.include?('imported')
    tax_exempt = tax_exempt?(description)

    # Clean up the name (remove "imported" prefix for cleaner output)
    name = description.gsub(/\bimported\s+/, '').strip
    name = "imported #{name}" if imported

    Item.new(
      name: name,
      quantity: quantity,
      unit_price: unit_price,
      imported: imported,
      tax_exempt: tax_exempt
    )
  end

  def self.tax_exempt?(description)
    TAX_EXEMPT_KEYWORDS.any? { |keyword| description.include?(keyword) }
  end
end
