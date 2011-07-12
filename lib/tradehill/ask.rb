require 'tradehill/offer'

module TradeHill
  class Ask < Offer

    def eprice
      price / (1 - commission)
    end

  end
end
