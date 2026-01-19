# frozen_string_literal: true

require_relative '../lib/shopping_basket'
require_relative '../lib/item'
require_relative '../lib/tax_calculator'

RSpec.describe ShoppingBasket do
  let(:basket) { ShoppingBasket.new }

  describe '#add_item' do
    it 'adds items to the basket' do
      item = Item.new(name: 'book', quantity: 1, unit_price: 10.00, tax_exempt: true)
      basket.add_item(item)
      expect(basket.items).to include(item)
    end
  end

  describe '#total_tax' do
    it 'returns zero for empty basket' do
      expect(basket.total_tax).to eq(0.0)
    end

    it 'calculates total tax for multiple items' do
      item1 = Item.new(name: 'book', quantity: 1, unit_price: 12.49, tax_exempt: true)
      item2 = Item.new(name: 'music CD', quantity: 1, unit_price: 14.99, tax_exempt: false)
      basket.add_item(item1)
      basket.add_item(item2)
      # Book: 0.0 tax
      # CD: 14.99 * 0.10 = 1.499, rounded to 1.50
      expect(basket.total_tax).to eq(1.50)
    end

    it 'handles imported items correctly' do
      item = Item.new(
        name: 'imported perfume',
        quantity: 1,
        unit_price: 47.50,
        imported: true,
        tax_exempt: false
      )
      basket.add_item(item)
      # 47.50 * 0.10 = 4.75 (basic)
      # 47.50 * 0.05 = 2.375 (import)
      # Total: 7.125, rounded to 7.15
      expect(basket.total_tax).to eq(7.15)
    end
  end

  describe '#total_price' do
    it 'returns zero for empty basket' do
      expect(basket.total_price).to eq(0.0)
    end

    it 'calculates total price including tax' do
      item1 = Item.new(name: 'book', quantity: 2, unit_price: 12.49, tax_exempt: true)
      item2 = Item.new(name: 'music CD', quantity: 1, unit_price: 14.99, tax_exempt: false)
      basket.add_item(item1)
      basket.add_item(item2)
      # Book: 24.98 (no tax)
      # CD: 14.99 + 1.50 tax = 16.49
      # Total: 24.98 + 16.49 = 41.47
      expect(basket.total_price).to eq(41.47)
    end
  end

  describe 'composition with TaxCalculator' do
    it 'uses TaxCalculator via dependency injection' do
      fake_calculator = double('TaxCalculator')
      allow(fake_calculator).to receive(:calculate).and_return(1.0)
      basket = ShoppingBasket.new(tax_calculator: fake_calculator)
      item = Item.new(name: 'item', quantity: 1, unit_price: 10.00, tax_exempt: false)
      basket.add_item(item)
      expect(fake_calculator).to receive(:calculate).with(item)
      basket.total_tax
    end
  end
end
