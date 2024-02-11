# frozen_string_literal: true

# This class is responsible for creating a product with a code, name and price.
class Product
  attr_reader :code, :name, :price, :discount

  def initialize(code, name, price, discount = nil)
    @code = code
    @name = name
    @price = price
    @discount = discount
  end

  def calculate_price_for(quantity)
    discount ? discount.apply(quantity, price) : price * quantity
  end
end
