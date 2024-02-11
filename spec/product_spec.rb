# frozen_string_literal: true

require_relative '../lib/product'

RSpec.describe Product do
  describe '#initialize' do
    let(:code) { 'PROD-001' }
    let(:name) { 'Example Product' }
    let(:price) { 9.99 }

    it 'creates a product with the given code, name and price' do
      product = described_class.new(code, name, price)

      expect(product.code).to eq(code)
      expect(product.name).to eq(name)
      expect(product.price).to eq(price)
    end
  end

  describe '#calculate_price_for' do
    context 'with no discount' do
      let(:product) { described_class.new('PROD-001', 'Example Product', 9.99) }

      it 'returns the total price for the given quantity' do
        expect(product.calculate_price_for(1)).to eq(9.99)
        expect(product.calculate_price_for(2)).to eq(19.98)
      end
    end

    context 'with a discount' do
      let(:buy_one_get_one_free) { Offer::VolumeDiscountOffer.new(2, 1) }
      let(:product) { described_class.new('PROD-001', 'Example Product', 9.99, buy_one_get_one_free) }

      it 'returns the total price for the given quantity with the discount applied' do
        expect(product.calculate_price_for(1)).to eq(9.99)
        expect(product.calculate_price_for(2)).to eq(9.99)
        expect(product.calculate_price_for(3)).to eq(19.98)
      end
    end
  end
end
