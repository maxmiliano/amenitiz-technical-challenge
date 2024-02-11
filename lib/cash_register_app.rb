# frozen_string_literal: true

require 'thor'
require 'tty-prompt'
require_relative 'cart'
require_relative 'product'
require_relative 'offer'

# CashRegisterApp is a command line interface for a cash register
class CashRegisterApp < Thor
  def initialize(args = [], local_options = {}, config = {})
    super
    load_products_sample_data
    @cart = Cart.new
  end

  desc 'start', 'Start the cash register'
  def start
    prompt_for_products
    print_cart_total
  end

  private

  def load_products_sample_data
    green_tea_offer = Offer::VolumeDiscountOffer.new(2, 1)
    strawberries_offer = Offer::QuantityThresholdDiscount.new(3, 4.50)
    coffee_offer = Offer::QuantityThresholdDiscount.new(3, 11.23 * 2 / 3)

    @products = [
      Product.new('GR1', 'Green Tea', 3.11, green_tea_offer),
      Product.new('SR1', 'Strawberries', 5.00, strawberries_offer),
      Product.new('CF1', 'Coffee', 11.23, coffee_offer)
    ]
  end

  def prompt_for_products
    prompt = TTY::Prompt.new
    loop do
      input = prompt.ask('Enter the product code: (empty to finish)', default: '')
      break if input.empty?

      handle_product_input(input)
    end
  end

  def handle_product_input(input)
    product = fetch_product(input)
    if product
      @cart.add(product)
      puts "Current total: #{format('%.2f', @cart.total)}€"
    else
      puts "Product #{input} not found"
    end
  end

  def fetch_product(code)
    @products.find { |prod| prod.code == code }
  end

  def print_cart_total
    puts "Final total: #{format('%.2f', @cart.total)}€"
  end
end

CashRegisterApp.start(ARGV)
