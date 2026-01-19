# frozen_string_literal: true

require_relative '../lib/tax_calculator'
require_relative '../lib/item'

RSpec.describe TaxCalculator do
  describe '.calculate' do
    context 'with basic tax-exempt items' do
      it 'applies no tax to books' do
        item = Item.new(name: 'book', quantity: 1, unit_price: 12.49, tax_exempt: true)
        expect(TaxCalculator.calculate(item)).to eq(0.0)
      end

      it 'applies no tax to food' do
        item = Item.new(name: 'chocolate bar', quantity: 1, unit_price: 0.85, tax_exempt: true)
        expect(TaxCalculator.calculate(item)).to eq(0.0)
      end

      it 'applies no tax to medical products' do
        item = Item.new(name: 'headache pills', quantity: 1, unit_price: 9.75, tax_exempt: true)
        expect(TaxCalculator.calculate(item)).to eq(0.0)
      end
    end

    context 'with non-exempt items' do
      it 'applies 10% basic tax to music CD' do
        item = Item.new(name: 'music CD', quantity: 1, unit_price: 14.99, tax_exempt: false)
        tax = TaxCalculator.calculate(item)
        # 14.99 * 0.10 = 1.499, rounded up to 1.50
        expect(tax).to eq(1.50)
      end

      it 'applies 10% basic tax to perfume' do
        item = Item.new(name: 'perfume', quantity: 1, unit_price: 18.99, tax_exempt: false)
        tax = TaxCalculator.calculate(item)
        # 18.99 * 0.10 = 1.899, rounded up to 1.90
        expect(tax).to eq(1.90)
      end
    end

    context 'with imported items' do
      it 'applies 5% import tax to imported tax-exempt items' do
        item = Item.new(
          name: 'imported chocolates',
          quantity: 1,
          unit_price: 10.00,
          imported: true,
          tax_exempt: true
        )
        tax = TaxCalculator.calculate(item)
        # 10.00 * 0.05 = 0.50
        expect(tax).to eq(0.50)
      end

      it 'applies both basic and import tax to imported non-exempt items' do
        item = Item.new(
          name: 'imported perfume',
          quantity: 1,
          unit_price: 47.50,
          imported: true,
          tax_exempt: false
        )
        tax = TaxCalculator.calculate(item)
        # 47.50 * 0.10 = 4.75 (basic)
        # 47.50 * 0.05 = 2.375 (import)
        # Total: 7.125, rounded up to 7.15
        expect(tax).to eq(7.15)
      end
    end

    context 'with rounding' do
      it 'rounds up to nearest 0.05' do
        item = Item.new(name: 'item', quantity: 1, unit_price: 1.00, tax_exempt: false)
        tax = TaxCalculator.calculate(item)
        # 1.00 * 0.10 = 0.10, which is already at 0.05 boundary
        expect(tax).to eq(0.10)
      end

      it 'rounds 1.01 up to 1.05' do
        # Create a scenario where tax would be 1.01
        item = Item.new(name: 'item', quantity: 1, unit_price: 10.06, tax_exempt: false)
        tax = TaxCalculator.calculate(item)
        # 10.06 * 0.10 = 1.006, rounded up to 1.05
        expect(tax).to eq(1.05)
      end
    end

    context 'with multiple quantities' do
      it 'calculates tax based on total price' do
        item = Item.new(name: 'book', quantity: 2, unit_price: 12.49, tax_exempt: true)
        tax = TaxCalculator.calculate(item)
        expect(tax).to eq(0.0)
      end

      it 'calculates tax for multiple imported items' do
        item = Item.new(
          name: 'imported chocolates',
          quantity: 3,
          unit_price: 11.25,
          imported: true,
          tax_exempt: true
        )
        tax = TaxCalculator.calculate(item)
        # Per unit: 11.25 * 0.05 = 0.5625, rounded up to 0.60
        # Total: 3 * 0.60 = 1.80
        expect(tax).to eq(1.80)
      end
    end
  end

  describe '.round_up_to_nearest_0_05' do
    it 'rounds 0.00 to 0.00' do
      expect(TaxCalculator.round_up_to_nearest_0_05(0.00)).to eq(0.00)
    end

    it 'rounds 0.01 to 0.05' do
      expect(TaxCalculator.round_up_to_nearest_0_05(0.01)).to eq(0.05)
    end

    it 'rounds 0.05 to 0.05' do
      expect(TaxCalculator.round_up_to_nearest_0_05(0.05)).to eq(0.05)
    end

    it 'rounds 0.06 to 0.10' do
      expect(TaxCalculator.round_up_to_nearest_0_05(0.06)).to eq(0.10)
    end

    it 'rounds 1.01 to 1.05' do
      expect(TaxCalculator.round_up_to_nearest_0_05(1.01)).to eq(1.05)
    end

    it 'rounds 1.50 to 1.50' do
      expect(TaxCalculator.round_up_to_nearest_0_05(1.50)).to eq(1.50)
    end
  end
end
