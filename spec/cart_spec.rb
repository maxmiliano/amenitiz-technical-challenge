# frozen_string_literal: true

require 'spec_helper'
require 'cart'
require 'product'
require 'offer'

RSpec.describe Cart do
  let(:green_tea) { Product.new('GR1', 'Green Tea', 3.11) }
  let(:strawberries) { Product.new('SR1', 'Strawberries', 5.00) }
  let(:coffee) { Product.new('CF1', 'Coffee', 11.23) }
  let(:cart) { described_class.new }

  describe '#add' do
    context 'when adding a product to the empty cart' do
      before do
        cart.add(green_tea)
      end

      it 'adds the right product to the cart' do
        expect(cart.items[green_tea.code][:product]).to eq(green_tea)
      end

      it 'adds the right quantity of the product to the cart' do
        expect(cart.items[green_tea.code][:quantity]).to eq(1)
      end
    end

    context 'when adding a product to the cart more than once' do
      before do
        2.times { cart.add(green_tea) }
      end

      it 'adds the right quantity of the product to the cart' do
        expect(cart.items[green_tea.code][:quantity]).to eq(2)
      end
    end

    context 'when adding different products to the cart' do
      before do
        2.times { cart.add(green_tea) }
        3.times { cart.add(strawberries) }
        cart.add(coffee)
      end

      it 'adds the right products to the cart' do
        expect(cart.items).to match(
          green_tea.code => { product: green_tea, quantity: 2 },
          strawberries.code => { product: strawberries, quantity: 3 },
          coffee.code => { product: coffee, quantity: 1 }
        )
      end
    end

    context 'when adding nil product' do
      it 'raises an error' do
        expect { cart.add(nil) }.to raise_error(ArgumentError, 'Product cannot be nil')
      end
    end
  end

  describe '#total' do
    context 'with no products in the cart' do
      it 'has an empty cart' do
        expect(cart).to be_empty
      end

      it 'returns 0 for total' do
        expect(cart.total).to eq(0)
      end
    end

    context 'with products in the cart' do
      context 'with no discounts applied' do
        before do
          2.times { cart.add(green_tea) }
          cart.add(strawberries)
        end

        let(:expected_total) { (green_tea.price * 2) + strawberries.price }

        it 'returns the total price for the products in the cart' do
          expect(cart.total).to eq(expected_total)
        end
      end

      context 'with offer strategies' do
        let(:buy_one_get_one_free) { Offer::VolumeDiscountOffer.new(2, 1) }
        let(:green_tea) { Product.new('GR1', 'Green Tea', 3.11, buy_one_get_one_free) }

        let(:buy_three_or_more) { Offer::QuantityThresholdDiscount.new(3, 4.50) }
        let(:strawberries) { Product.new('SR1', 'Strawberries', 5.00, buy_three_or_more) }

        let(:coffee_price) { 11.23 }
        let(:buy_three_or_more_for_less) { Offer::QuantityThresholdDiscount.new(3, coffee_price * 2 / 3) }
        let(:coffee) { Product.new('CF1', 'Coffee', coffee_price, buy_three_or_more_for_less) }

        context 'when there are 2 green teas in the cart' do
          before do
            2.times { cart.add(green_tea) }
          end

          it 'applies the discount for 2 green teas' do
            expect(cart.total).to eq(3.11)
          end
        end

        context 'with 3 or more strawberries in the cart' do
          before do
            2.times { cart.add(strawberries) }
            cart.add(green_tea)
            cart.add(strawberries)
          end

          it 'applies the discount for 3 or more strawberries' do
            expect(cart.total).to eq(16.61)
          end
        end

        context 'with 3 coffees in the cart added with other products' do
          before do
            cart.add(green_tea)
            cart.add(coffee)
            cart.add(strawberries)
            2.times { cart.add(coffee) }
          end

          it 'applies the discount for 3 coffees' do
            expect(cart.total).to eq(30.57)
          end
        end
      end
    end
  end
end
