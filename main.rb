#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/shopping_basket'
require_relative 'lib/receipt'
require_relative 'lib/input_parser'

def process_input(input_lines)
  basket = ShoppingBasket.new
  input_lines.each do |line|
    item = InputParser.parse_line(line)
    basket.add_item(item) if item
  end
  receipt = Receipt.new(basket)
  puts receipt
  puts # blank line between outputs
end

# Input 1
puts "Input 1:"
input1 = [
  '2 book at 12.49',
  '1 music CD at 14.99',
  '1 chocolate bar at 0.85'
]
process_input(input1)

# Input 2
puts "Input 2:"
input2 = [
  '1 imported box of chocolates at 10.00',
  '1 imported bottle of perfume at 47.50'
]
process_input(input2)

# Input 3
puts "Input 3:"
input3 = [
  '1 imported bottle of perfume at 27.99',
  '1 bottle of perfume at 18.99',
  '1 packet of headache pills at 9.75',
  '3 imported boxes of chocolates at 11.25'
]
process_input(input3)
