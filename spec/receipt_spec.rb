# frozen_string_literal: true

require_relative '../lib/receipt'
require_relative '../lib/shopping_basket'
require_relative '../lib/item'

RSpec.describe Receipt do
  describe '#to_s' do
    it 'formats receipt for Input 1' do
      basket = ShoppingBasket.new
      basket.add_item(Item.new(name: 'book', quantity: 2, unit_price: 12.49, tax_exempt: true))
      basket.add_item(Item.new(name: 'music CD', quantity: 1, unit_price: 14.99, tax_exempt: false))
      basket.add_item(Item.new(name: 'chocolate bar', quantity: 1, unit_price: 0.85, tax_exempt: true))

      receipt = Receipt.new(basket)
      output = receipt.to_s

      expect(output).to include('2 book: 24.98')
      expect(output).to include('1 music CD: 16.49')
      expect(output).to include('1 chocolate bar: 0.85')
      expect(output).to include('Sales Taxes: 1.50')
      expect(output).to include('Total: 42.32')
    end

    it 'formats receipt for Input 2' do
      basket = ShoppingBasket.new
      basket.add_item(Item.new(
        name: 'imported box of chocolates',
        quantity: 1,
        unit_price: 10.00,
        imported: true,
        tax_exempt: true
      ))
      basket.add_item(Item.new(
        name: 'imported bottle of perfume',
        quantity: 1,
        unit_price: 47.50,
        imported: true,
        tax_exempt: false
      ))

      receipt = Receipt.new(basket)
      output = receipt.to_s

      expect(output).to include('1 imported box of chocolates: 10.50')
      expect(output).to include('1 imported bottle of perfume: 54.65')
      expect(output).to include('Sales Taxes: 7.65')
      expect(output).to include('Total: 65.15')
    end

    it 'formats receipt for Input 3' do
      basket = ShoppingBasket.new
      basket.add_item(Item.new(
        name: 'imported bottle of perfume',
        quantity: 1,
        unit_price: 27.99,
        imported: true,
        tax_exempt: false
      ))
      basket.add_item(Item.new(name: 'bottle of perfume', quantity: 1, unit_price: 18.99, tax_exempt: false))
      basket.add_item(Item.new(name: 'packet of headache pills', quantity: 1, unit_price: 9.75, tax_exempt: true))
      basket.add_item(Item.new(
        name: 'imported boxes of chocolates',
        quantity: 3,
        unit_price: 11.25,
        imported: true,
        tax_exempt: true
      ))

      receipt = Receipt.new(basket)
      output = receipt.to_s

      expect(output).to include('1 imported bottle of perfume: 32.19')
      expect(output).to include('1 bottle of perfume: 20.89')
      expect(output).to include('1 packet of headache pills: 9.75')
      expect(output).to include('3 imported boxes of chocolates: 35.55')
      expect(output).to include('Sales Taxes: 7.90')
      expect(output).to include('Total: 98.38')
    end

    it 'formats prices with two decimal places' do
      basket = ShoppingBasket.new
      basket.add_item(Item.new(name: 'item', quantity: 1, unit_price: 10.00, tax_exempt: false))
      receipt = Receipt.new(basket)
      output = receipt.to_s
      expect(output).to match(/\d+\.\d{2}/)
    end
  end
end
