# frozen_string_literal: true

require 'rspec'
require 'offer'

describe Offer do
  it 'raises an error when calling abstract apply' do
    expect { subject.apply(1, 9.99) }.to raise_error(NotImplementedError, "Offer has not implemented method 'apply'")
  end

  describe Offer::VolumeDiscountOffer do
    subject { described_class.new(offer_quantity, free_quantity) }

    let(:offer_quantity) { 3 }
    let(:free_quantity) { 1 }
    let(:price) { 10.0 }

    it 'applies the discount for exact bulk match' do
      expect(subject.apply(3, price)).to eq(20.0)
    end

    it 'applies the discount for the bulk and not for the remainders' do
      expect(subject.apply(4, price)).to eq(30.0)
    end

    it 'applies the discount for multiple bulks' do
      expect(subject.apply(6, price)).to eq(40.0)
    end
  end

  describe Offer::QuantityThresholdDiscount do
    subject { described_class.new(offer_amount, offer_price) }

    let(:offer_amount) { 3 }
    let(:price) { 10.0 }
    let(:offer_price) { 8.5 }

    context 'when quantity is less than the offer amount' do
      it 'does not apply the discount' do
        expect(subject.apply(2, price)).to eq(20.0)
      end
    end

    context 'when quantity is equal to the offer amount' do
      it 'applies the discount' do
        expect(subject.apply(3, price)).to eq(25.5)
      end
    end

    context 'when quantity is greater than the offer amount' do
      it 'applies the discount' do
        expect(subject.apply(4, price)).to eq(34.0)
      end
    end
  end
end
