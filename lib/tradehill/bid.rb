require 'tradehill/offer'

module TradeHill
  class Bid < Offer

    def eprice
      price * (1 - commission)
    end

  end
end
