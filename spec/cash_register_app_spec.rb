# frozen_string_literal: true

require 'spec_helper'
require 'cash_register_app'

RSpec.describe CashRegisterApp do
  subject(:cash_register_app) { described_class.new }

  describe '#start' do
    it 'prompts for products and prints the cart total' do
      allow(cash_register_app).to receive(:prompt_for_products)
      allow(cash_register_app).to receive(:print_cart_total)

      cash_register_app.start

      expect(cash_register_app).to have_received(:prompt_for_products)
      expect(cash_register_app).to have_received(:print_cart_total)
    end
  end

  describe '#handle_product_input' do
    let(:product) { instance_double(Product, code: 'GR1') }

    before do
      allow(cash_register_app).to receive(:fetch_product).with('GR1').and_return(product)
      allow(cash_register_app).to receive(:fetch_product).with('INVALID').and_return(nil)
      allow(cash_register_app).to receive(:print_cart_total)
      allow(product).to receive(:calculate_price_for).with(1).and_return(3.11)
    end

    it 'adds the product to the cart and prints the cart total' do
      allow(cash_register_app).to receive(:puts)
      cash_register_app.send(:handle_product_input, 'GR1')

      expect(cash_register_app).to have_received(:fetch_product).with('GR1')
    end

    it 'prints a message when the product is not found' do
      expect do
        cash_register_app.send(:handle_product_input, 'INVALID')
      end.to output("Product INVALID not found\n").to_stdout
    end
  end
end
