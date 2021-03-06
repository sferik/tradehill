require 'tradehill/ask'
require 'tradehill/price_ticker'
require 'singleton'

module TradeHill
  class MinAsk < Ask
    include Singleton
    include PriceTicker
  end
end
