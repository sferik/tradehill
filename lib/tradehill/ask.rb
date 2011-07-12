require 'tradehill/offer'

module TradeHill
  class Ask < Offer

    def initialize(price=nil, amount=nil)
      self.price = price.to_f
      self.amount = amount.to_f
    end

    def eprice
      price / (1 - TradeHill.commission)
    end

  end
end
