# frozen_string_literal: true

# Offer class is a base class for all the offers
# It has a method apply which is implemented by the child classes
class Offer
  def apply(quantity, price)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # This class is responsible for applying a discount when buying x products and getting y for free.
  # Examples:
  # - Buy 1 green teas and get 1 for free (which means buying a bulk of 2 for the price of 1)
  # - Buy 3 oranges and get 2 for free (which is equivalent to buy a bulk of 5 for the price of 3)
  class VolumeDiscountOffer < Offer
    def initialize(offer_quantity, free_quantity)
      super()
      @offer_quantity = offer_quantity
      @free_quantity = free_quantity
    end

    def apply(quantity, price)
      ((quantity / @offer_quantity) * (@offer_quantity - @free_quantity) * price) +
        ((quantity % @offer_quantity) * price)
    end
  end

  # This class is responsible for applying a discount when buying more than x products.
  # Example: Buy 3 or more strawberries and pay only $4.50 each
  class QuantityThresholdDiscount < Offer
    def initialize(offer_amount, offer_price)
      super()
      @offer_amount = offer_amount
      @offer_price = offer_price
    end

    def apply(quantity, price)
      quantity >= @offer_amount ? quantity * @offer_price : quantity * price
    end
  end
end
