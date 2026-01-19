# frozen_string_literal: true

require_relative '../lib/input_parser'

RSpec.describe InputParser do
  describe '.parse_line' do
    it 'parses a simple book line' do
      item = InputParser.parse_line('2 book at 12.49')
      expect(item.name).to eq('book')
      expect(item.quantity).to eq(2)
      expect(item.unit_price).to eq(12.49)
      expect(item.imported).to be false
      expect(item.tax_exempt).to be true
    end

    it 'parses a music CD line' do
      item = InputParser.parse_line('1 music CD at 14.99')
      expect(item.name).to eq('music CD')
      expect(item.quantity).to eq(1)
      expect(item.unit_price).to eq(14.99)
      expect(item.imported).to be false
      expect(item.tax_exempt).to be false
    end

    it 'detects imported items' do
      item = InputParser.parse_line('1 imported box of chocolates at 10.00')
      expect(item.name).to eq('imported box of chocolates')
      expect(item.imported).to be true
      expect(item.tax_exempt).to be true
    end

    it 'detects tax-exempt items by keyword' do
      item = InputParser.parse_line('1 chocolate bar at 0.85')
      expect(item.tax_exempt).to be true
    end

    it 'detects medical products as tax-exempt' do
      item = InputParser.parse_line('1 packet of headache pills at 9.75')
      expect(item.tax_exempt).to be true
    end

    it 'handles multiple quantities' do
      item = InputParser.parse_line('3 imported boxes of chocolates at 11.25')
      expect(item.quantity).to eq(3)
      expect(item.unit_price).to eq(11.25)
      expect(item.imported).to be true
    end

    it 'returns nil for invalid input' do
      expect(InputParser.parse_line('invalid input')).to be_nil
    end
  end

  describe '.tax_exempt?' do
    it 'identifies books as tax-exempt' do
      expect(InputParser.tax_exempt?('book')).to be true
    end

    it 'identifies chocolate as tax-exempt' do
      expect(InputParser.tax_exempt?('chocolate bar')).to be true
    end

    it 'identifies pills as tax-exempt' do
      expect(InputParser.tax_exempt?('headache pills')).to be true
    end

    it 'identifies non-exempt items' do
      expect(InputParser.tax_exempt?('music CD')).to be false
      expect(InputParser.tax_exempt?('perfume')).to be false
    end
  end
end
