# frozen_string_literal: true

# This class is responsible for managing the items in the cart and calculating the total price.
class Cart
  attr_reader :items

  def initialize
    @items = {}
  end

  def add(product)
    raise ArgumentError, 'Product cannot be nil' unless product

    @items[product.code] ||= { product:, quantity: 0 }
    @items[product.code][:quantity] += 1
  end

  def total
    @items.values.reduce(0) do |total, item|
      total + item[:product].calculate_price_for(item[:quantity])
    end
  end

  def empty?
    @items.empty?
  end
end
