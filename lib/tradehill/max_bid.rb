require 'tradehill/bid'
require 'tradehill/price_ticker'
require 'singleton'

module TradeHill
  class MaxBid < Bid
    include Singleton
    include PriceTicker
  end
end
